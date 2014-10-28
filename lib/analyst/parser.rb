require 'fileutils'

module Analyst

  class Parser

    attr_reader :context_stack, :start_path

    def initialize(ast)
      @ast = ast
      @context_stack = ContextStack.new
    end

    def classes

    end

    private

    def processors
      @processors ||= Hash.new(:default_processor).merge!(
        :class => :class_processor,
        # :module => :module_node_parser,
        # :def => :method_node_parser,
        # :send => :send_node_parser
        # TODO: make a method parser, which pushes the the context_stack so that things inside method bodies
        # are treated differently than those inside class or module bodies.  same with Block (right?)
      )
    end

    # search the whole tree for classes
    def parse_ast(node=ast)
      # files can start with (module), (class), or (begin)
      # EDIT: or (send), or (def), or.... just about anything
      return unless node.respond_to? :type
      send(processors[node.type], node)
    end

    def class_processor(node)
      name_node, super_node, content_node = node.children
      klass = Entities::Class.new(self.context_stack.last, node)
      @classes << klass
      self.context_stack.push klass
      parse_ast(content_node)
      self.context_stack.pop
    end

    def parsed_files
      @parsed_files = source_files.map do |path_to_file|
         extract_classes(path_to_file)
      end
    end

    # def extract_classes
    #   classes = []
    #   files.each {|f| f.classes.each {|c| merge_class(classes, c) } }
    #   classes
    # end

    def source_files
      if File.directory?(start_path)
        return Dir.glob(File.join(start_path, "**", "*.rb"))
      else
        return [start_path]
      end
    end

    def parse_source_file(path_to_file, options={})
      ParsedFile.new(path_to_file: path_to_file)
    end

  end

end