module Analyst
  module Entities
    class MethodCall < Entity

      def name
        name_node.to_s
      end

      def full_name
        name
      end

      def arguments
        @arguments ||= begin
          args = ast.children[2..-1]
          args.map { |arg| Analyst::Parser.process_node(arg, self) }
        end
      end

      def constants
        if target_is_constant?
          super
        else
          super << target
        end
      end

      private

      def target_node
        ast.children.first
      end

      def target
        process_node(target_node)
      end

      def target_is_constant?
        target.is_a?(Analyst::Entities::Constant)
      end

      def name_node
        ast.children[1]
      end

    end
  end
end

