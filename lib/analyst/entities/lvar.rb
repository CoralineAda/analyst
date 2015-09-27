module Analyst

  module Entities
    class Lvar < Entity

      handles_node :lvar

      def name
        name_node.to_s
      end

      def full_name
        (scope.nil? ? parent.full_name : scope.full_name) + '::' + name
      end

      def scope
        @scope ||= process_node(ast.children.first)
      end

      private

      def name_node
        ast.children.first
      end
    end
  end
end

