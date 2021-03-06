module Analyst

  module Entities
    class VariableAssignment < Entity

      handles_node :lvasgn

      def name
        name_node.to_s
      end

      def full_name
        (scope.nil? ? parent.full_name : scope.full_name) + '::' + name
      end

      def scope
        @scope ||= process_node(ast.children.first)
      end

      def value
        @value ||= process_nodes(ast.children)
      end

      private

      def name_node
        ast.children[1].children.first
      end
    end
  end
end

