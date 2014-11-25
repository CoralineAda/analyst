module Analyst

  module Entities
    class ConstantAssignment < Entity

      handles_node :casgn

      def name
        name_node.to_s
      end

      def full_name
        parent.nil? ? name : parent.full_name + '::' + name
      end

      private

      def name_node
        ast.children[1]
      end
    end
  end
end

