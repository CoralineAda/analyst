module Analyst

  module Entities

    class File < Entity

      handles_node :analyst_file

      def full_name
        ""
      end

      def file_path
        parent.source_data_for(self)
      end

      def location
        file_path
      end

      def origin_source
        ::File.open(file_path, 'r').read
      end

      def contents
        @contents ||= actual_contents.map do |child|
          # skip top-level CodeBlocks
          child.is_a?(Entities::CodeBlock) ? child.contents : child
        end.flatten
      end

      private

      def source_range
        0..-1
      end

      def actual_contents
        @actual_contents ||= ast.children.map { |child| process_node(child) }
      end

    end

  end

end
