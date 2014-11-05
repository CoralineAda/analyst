module Analyst

  module Entities
    class Root < Entity

      def full_name
        ""
      end

      private

      def contents
        @contents ||= actual_contents.map do |child|
          # skip top-level CodeBlocks
          child.is_a?(Entities::CodeBlock) ? child.contents : child
        end.flatten
      end

      def actual_contents
        @actual_contents ||= ast.children.map { |child| process_node(child) }
      end

    end
  end
end

