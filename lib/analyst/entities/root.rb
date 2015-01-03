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
        @actual_contents ||= process_nodes(ast.children)
      end

    end
  end
end

