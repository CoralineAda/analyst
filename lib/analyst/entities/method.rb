module Analyst
  module Entities

    class InstanceMethod < Entity

      handles_node :def

      def kind
        "Instance Method"
      end

      def name
        ast.children.first.to_s
      end

      def full_name
        parent.full_name + '#' + name
      end
    end

    class ClassMethod < Entity
      def kind
        "Class Method"
      end

      def name
        ast.children.first.to_s
      end

      def full_name
        parent.full_name + '::' + name
      end
    end

    class SingletonMethod < Entity

      handles_node :defs

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
