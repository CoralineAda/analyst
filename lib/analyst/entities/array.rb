module Analyst

  module Entities
    class Array < Entity

      handles_node :array

      private

      def contents
        @contents ||= process_nodes(ast.children)
      end
    end
  end
end
