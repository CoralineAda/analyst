module Analyst

  module Entities
    class Root < Entity

      def classes
        @classes ||= children.select { |child| child.is_a? Analyst::Entities::Class }
      end

      def full_name
        ""
      end

      private

      def children
        @children ||= begin
          child_nodes = ast.children
          child_nodes.map { |child| Analyst::Parser.process_node(child, self) }.flatten
        end
      end

    end
  end
end

