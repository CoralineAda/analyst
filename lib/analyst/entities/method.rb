module Analyst
  module Entities
    class InstanceMethod < Entity
      def name
        ast.children.first.to_s
      end
      def full_name
        parent.full_name + '#' + name
      end
    end
    class ClassMethod < Entity
      def name
        ast.children.first.to_s
      end
      def full_name
        parent.full_name + '#' + name
      end
    end
  end
end
