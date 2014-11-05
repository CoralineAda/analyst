module Analyst

  module Entities
    class Array < Entity

      private

      def contents
        @contents ||= ast.children.map { |child| process_node(child) }
      end
    end
  end
end
