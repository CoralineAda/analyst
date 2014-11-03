module Analyst

  module Entities
    class Root < Entity

      def full_name
        ""
      end

      def contents
        @contents ||= begin
          child_nodes = ast.children
          child_nodes.map { |child| Analyst::Parser.process_node(child, self) }.flatten
        end
      end

    end
  end
end

