module Analyst

  module Entities

    class Root < Entity

      handles_node :analyst_root

      def initialize(ast, source_data)
        @source_data = source_data
        super(ast, nil)
      end

      def full_name
        ""
      end

      def source_data_for(entity)
        source_data[actual_contents.index(entity)]
      end

      def file_path
        throw "Entity tree malformed - Source or File should have caught this call"
      end

      def origin_source
        throw "Entity tree malformed - Source or File hsould have caught this call"
      end

      def contents
        # skip all top-level entities, cuz they're all Files and Sources
        @contents ||= actual_contents.map(&:contents).flatten
      end

       private

      attr_reader :source_data

     def actual_contents
        @actual_contents ||= ast.children.map { |child| process_node(child) }
      end

    end
  end
end

