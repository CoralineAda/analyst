module Analyst

  module Entities

    class Root < Entity

      handles_node :analyst_root

      def full_name
        ""
      end

      def inspect
        "\#<#{self.class}>"
      end

      def contents
        @contents ||= actual_contents.map do |child|
          # skip top-level CodeBlocks
          child.is_a?(Entities::CodeBlock) ? child.contents : child
        end.flatten
      end

      private

      def actual_contents
        @actual_contents ||= ast.children.map { |child| process_node(child) }
      end

    end
  end
end

