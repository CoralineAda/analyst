module Analyst

  module Entities
    class Pair < Entity

      handles_node :pair

      def key
        @key ||= process_node(ast.children[0])
      end

      def value
        @value ||= process_node(ast.children[1])
      end

      private

      def contents
        [key, value]
      end
    end
  end
end
