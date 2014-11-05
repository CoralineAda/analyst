require 'fileutils'
require 'pry'

module Analyst

  class Parser

    extend Forwardable

    attr_reader :start_path

    def_delegators :root, :classes, :top_level_classes, :constants,
                          :methods

    PROCESSORS = Hash.new(Entities::Empty).merge!(
      :root     => Entities::Root,
      :class    => Entities::Class,
      :def      => Entities::InstanceMethod,
      :defs     => Entities::SingletonMethod,
      :begin    => Entities::CodeBlock,
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
