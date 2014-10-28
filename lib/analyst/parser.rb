require 'fileutils'

module Analyst

  class Parser

    extend Forwardable

    attr_reader :context_stack, :start_path

    def_delegator :root, :classes

    # TODO: Empty -> Unhandled (or something like that)
    PROCESSORS = Hash.new(Entities::Empty).merge!(
      :root => Entities::Root,
      :class => Entities::Class,
    # :module => :module_node_parser,
    # :def => :method_node_parser,
    # :send => :send_node_parser
    # TODO: make a method parser, which pushes the the context_stack so that things inside method bodies
    # are treated differently than those inside class or module bodies.  same with Block (right?)
    )

    def self.process_node(node, parent)
      PROCESSORS[node.type].new(node, parent)
    end

    def initialize(ast)
      @ast = ast
      @context_stack = ContextStack.new
    end

    private

    def root
      @root ||= self.class.process_node(@ast, nil)
    end

  end

end