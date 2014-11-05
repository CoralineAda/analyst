module Analyst

  module Entities
    class Pair < Entity

      handles_node :pair

      def key
        process_node(ast.children[0])
      end

      def value
        process_node(ast.children[1])
      end
    end
  end
end
