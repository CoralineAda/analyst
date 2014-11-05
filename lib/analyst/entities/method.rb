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
        parent.full_name + '::' + name
      end
    end

    class SingletonMethod < Entity

      # NOTE: not a public API -- used by Entities::Class
      def target
        target, name, params, content = ast.children
        target
      end

      def name
        ast.children[1].to_s
      end

      def full_name
        parent.full_name + '::' + name
      end
    end

  end
end
