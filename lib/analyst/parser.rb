require 'fileutils'
require 'pry'

module Analyst

  class Parser

    extend Forwardable

    attr_reader :start_path, :ast

    def_delegators :root, :classes, :top_level_classes, :modules, :top_level_modules

    PROCESSORS = Hash.new(Entities::Empty).merge!(
      :root     => Entities::Root,
      :class    => Entities::Class,
      :def      => Entities::InstanceMethod,
      :defs     => Entities::SingletonMethod,
      :begin    => Entities::Begin,
      :module   => Entities::Module,
      :send     => Entities::MethodCall,
      :sclass   => Entities::SingletonClass,
      :dstr     => Entities::InterpolatedString,
      :sym      => Entities::Symbol,
      :str      => Entities::String,
      :hash     => Entities::Hash,
      :pair     => Entities::Pair,
      :const    => Entities::Constant,
      :if       => Entities::Conditional,
      :or_asgn  => Entities::Conditional,
      :and_sgn  => Entities::Conditional,
      :or       => Entities::Conditional,
      :and      => Entities::Conditional
    )

    def self.process_node(node, parent)
      return if node.nil?
      return unless node.respond_to?(:type)
      PROCESSORS[node.type].new(node, parent)
    end

    def self.from_source(source)
      new(::Parser::AST::Node.new(:root, [::Parser::CurrentRuby.parse(source)]))
    end

    def initialize(ast)
      @ast = ast
    end

    def inspect
      "\#<#{self.class}:#{object_id}>"
    end

    def source_for(entity)
      #TODO: implement me
    end

    private

    def root
      @root ||= self.class.process_node(@ast, nil)
    end

  end

end
