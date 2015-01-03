module Analyst

  module Entities
    class CodeBlock < Entity
      extend Forwardable

      handles_node :begin

      def_delegators :parent, :name, :full_name

      def contents
        @contents ||= process_nodes(ast.children)
      end

    end
  end
end

