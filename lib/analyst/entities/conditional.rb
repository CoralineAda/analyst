module Analyst

  module Entities
    class Conditional < Entity

      handles_node :if
      handles_node :or
      handles_node :and
      handles_node :or_asgn
      handles_node :and_asgn

      private

      def contents
        @contents ||= process_nodes(ast.children).compact
      end
    end
  end
end
