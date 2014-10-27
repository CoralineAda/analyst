require 'pry'

module Z

  class Parser
    extend Forwardable

    attr_reader :corpus

    def_delegators :@corpus, :classes, :associations

    def initialize(path)
      @corpus = Corpus.new(path)
    end

    def class_graph
      {
        nodes: corpus.classes,
        edges: corpus.associations
        #nodes: [1,2,3],
        #edges: [{source: 1, target: 2, strength: 1}, {source: 2, target: 1, strength: 4}]
      }
    end
  end


  class Corpus

    attr_reader :path, :classes, :associations

    def initialize(path)
      @path = path
      parse!
    end

    def files
      @files ||= file_paths.map {|path| File.new(path)}
    end

    def parse!
      @classes = extract_classes
      @associations = link_associations
      #@associations = combine_identical_associations
    end

    private

    def extract_classes
      classes = []
      files.each {|f| f.classes.each {|c| merge_class(classes, c) } }
      classes
    end

    def link_associations
      all = classes.map(&:associations).flatten
      all.each do |assoc|
        target = classes.detect {|c| c.full_name == assoc.target_class }
        if target
          assoc.target = target
        else
          puts "WARNING: Couldn't find target: #{assoc.target_class}"
        end
      end
    end

    def file_paths
      if ::File.directory?(path)
        Dir.glob(::File.join(path, "**", "*.rb"))
      else
        [path]
      end
    end

    def merge_class(classes, klass)
      existing = classes.find {|c| c.full_name == klass.full_name}
      if existing
        existing.merge(klass)
      else
        classes << klass
      end
    end

  end


  class File

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def contents
      @contents ||= ::File.open(path, 'r').read
    end

    def ast
      @ast ||= ::Parser::CurrentRuby.parse(contents)
    end

    def classes
      return @classes if @classes
      @classes = []
      parse!
      @classes
    end

    def parse!
      parse_ast
      true
    end

    private

    # to log node types that haven't been dealt with
    def unhandled_node_types
      @unhandled_node_types ||= Set.new
    end

    # contains Module, Class, Method... eventually Block and other stuff maybe
    def context_stack
      @context_stack ||= [Entities::Empty.new]
    end

    def node_parsers
      @node_parsers ||= Hash.new(:default_node_parser).merge!(
        :class => :class_node_parser,
        :module => :module_node_parser,
        :def => :method_node_parser,
        :send => :send_node_parser
        # TODO: make a method parser, which pushes the the context_stack so that things inside method bodies
        # are treated differently than those inside class or module bodies.  same with Block (right?)
      )
    end

    # search the whole tree for classes
    def parse_ast(node=ast)
      # files can start with (module), (class), or (begin)
      # EDIT: or (send), or (def), or.... just about anything
      return unless node.respond_to? :type
      send(node_parsers[node.type], node)
    end

    def default_node_parser(node)
      unhandled_node_types.add(node.type)
      return unless node.respond_to? :children
      node.children.each { |cnode| parse_ast(cnode) }
    end

    def class_node_parser(node)
      name_node, super_node, content_node = node.children
      klass = Entities::Class.new(context_stack.last, node)
      @classes << klass
      context_stack.push klass
      parse_ast(content_node)
      context_stack.pop
    end

    def module_node_parser(node)
      name_node, content_node = node.children
      mod = Entities::Module.new(context_stack.last, node)
      context_stack.push mod
      parse_ast(content_node)
      context_stack.pop
    end

    def method_node_parser(node)
      name, args_node, content_node = node.children
      method = Entities::Method.new(context_stack.last, node)
      context_stack.push method
      parse_ast(content_node)
      context_stack.pop
    end

    def send_node_parser(node)
      target_node, method_name, *args = node.children
      # if method_name is an association, then analyze the args to see what class it's associated with!
      # and "it", btw, is the context_stack.last... so ya, also make sure this analysis is only done when we're in a
      # class, NOT when we're in a method, NOT when we're in a defs, NOT when we're in an (sclass) (comes from
      # class << self) -- got that?? those nodes should push something like 'Unsupported' onto the stack, or something
      # just to keep track of where we are at any given point, and make sure we only care about sends that
      # are truly at the right scope.
      context_stack.last.handle_send_node(node)
      # basically, if it's a class, it'll see if this is an association.  if so, it'll store it by name. later on, we go
      # thru and connect the pointers.
    end
  end


  module Entities

    class Entity
      attr_reader :parent

      def handle_send_node(node)
        # abstract method.  btw, this feels wrong -- send should be an entity too.  but for now, whatevs.
      end

      def full_name
        throw "this is abstract method, fool"
      end

      def inspect
        "\#<#{self.class}:#{object_id} full_name=#{full_name}>"
      end
    end


    class Empty < Entity
      def full_name
        ''
      end
    end


    class Method < Entity
      attr_reader :ast

      def initialize(parent, ast)
        @parent = parent
        @ast = ast
      end

      def name
        ast.children.first.to_s
      end

      def full_name
        parent.full_name + '#' + name
      end
    end


    class Module < Entity
      attr_reader :ast

      def initialize(parent, ast)
        @parent = parent
        @ast = ast
      end

      def name
        const_node_array(ast.children.first).join('::')
      end

      def full_name
        parent.full_name.empty? ? name : parent.full_name + '::' + name
      end

      private

      # takes a (const) node and returns an array specifying the fully-qualified
      # constant name that it represents.  ya know, so CoolModule::SubMod::SweetClass
      # would be parsed to:
      # (const
      #   (const
      #     (const nil :CoolModule) :SubMod) :SweetClass)
      # and passing that node here would return [:CoolModule, :SubMod, :SweetClass]
      def const_node_array(node)
        return [] if node.nil?
        raise "expected (const) node or nil, got (#{node.type})" unless node.type == :const
        const_node_array(node.children.first) << node.children[1]
      end
    end


    class Class < Module

      # pretend, for now, that we always have an AR.  i.e., always look for associations.
      ASSOCIATIONS = [:belongs_to, :has_one, :has_many, :has_and_belongs_to_many]

      def handle_send_node(node)
        # FIXME: this doesn't feel right, cuz (send) should probably be an entity too, especially
        # since you can have nested sends... but i'm doing it this way for now.
        target, method_name, *args = node.children
        if ASSOCIATIONS.include? method_name
          add_association(method_name, args)
        end
      end

      def associations
        @associations ||= []
      end

      def merge(other_class)
        other_class.associations.each do |other_assoc|
          duplicate = associations.detect do |assoc|
            assoc.type == other_assoc.type && assoc.target_class == other_assoc.target_class
          end
          unless duplicate
            associations << Association.new(type: other_assoc.type, source: self, target_class: other_assoc.target_class)
          end
        end
      end

      private

      def add_association(method_name, args)
        if args.size > 1
          # args.last is a hash that might contain a class_name or a through
          target_class = hash_val_str(args.last, :class_name)
        end
        target_class ||= begin
                           symbol_node = args.first
                           symbol_name = symbol_node.children.first
                           table_name = ::ActiveSupport::Inflector.pluralize(symbol_name)
                           ::ActiveSupport::Inflector.classify(table_name)
                         end
        assoc = Association.new(type: method_name, source: self, target_class: target_class)
        associations << assoc
      end

      # give it a (hash) node and a key (a symbol) and it'll look for that key in the hash and
      # return the associated value as long as it's a string.  if key isn't found, returns nil.
      # if key is found but val isn't (str), throw exception. yep, this is pretty bespoke.
      def hash_val_str(node, key)
        return unless node.type == :hash
        pair = node.children.detect do |pair_node|
          key_sym_node = pair_node.children.first
          key == key_sym_node.children.first
        end
        if pair
          val_node = pair.children.last
          throw "Bad type. Expected (str), got (#{val_node.type})" unless val_node.type == :str
          val_node.children.first
        end
      end
    end

  end


  class Association
    attr_reader :type, :source, :target_class
    attr_accessor :target

    def initialize(type:, source:, target_class:)
      @type = type
      @source = source
      @target_class = target_class
    end
  end

end

