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
        if target.is_a? Analyst::Entities::Constant
          super << target
        else
          super
        end
      end

      private

      def contents
        arguments
      end

      def target_node
        ast.children.first
      end

      def target
        process_node(target_node)
      end

      def name_node
        ast.children[1]
      end

    end
  end
end

