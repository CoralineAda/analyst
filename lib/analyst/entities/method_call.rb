module Analyst
  module Entities
    class MethodCall < Entity

      handles_node :send

      def name
        name_node.to_s
      end

      def full_name
        name
      end

      def arguments
        @arguments ||= process_nodes(ast.children[2..-1])
      end

      private

      def contents
        (arguments + [target]).compact
      end

      def target_node
        ast.children.first
      end

      def target
        @target ||= process_node(target_node)
      end

      def name_node
        ast.children[1]
      end

    end
  end
end

