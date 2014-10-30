module Analyst
  module Entities
    class MethodCall < Entity

      def name
        name_node.to_s
      end

      def full_name
        name
      end

      # TODO: figure out how to resolve this to an Entity. we never want
      # to expose the AST to the outside.
      def target_node
        ast.children.first
      end

      private

      def name_node
        ast.children[1]
      end

    end
  end
end
