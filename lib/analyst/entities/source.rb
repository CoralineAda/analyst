module Analyst

  module Entities

    class Source < Entity

      handles_node :analyst_source

      def full_name
        ""
      end

      def file_path
        "$PARSED FROM SOURCE$"
      end

      def source
        parent.source_data_for(self)
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
