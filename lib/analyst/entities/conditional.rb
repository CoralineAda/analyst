module Analyst

  module Entities
    class Conditional < Entity

      handles_node :if
      handles_node :or
      handles_node :and
      handles_node :or_asgn
      handles_node :and_asgn

      private

      def contents
        @contents ||= ast.children.map { |child| process_node(child) }.compact
      end
    end
  end
end
