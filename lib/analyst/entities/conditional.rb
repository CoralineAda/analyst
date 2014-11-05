module Analyst

  module Entities
    class Conditional < Entity

      private

      def contents
        @contents ||= ast.children.map { |child| process_node(child) }.compact
      end
    end
  end
end
