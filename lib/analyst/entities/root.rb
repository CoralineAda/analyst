module Analyst

  module Entities
    class Root < Entity

      def classes
        @classes ||= children.select { |child| child.is_a? Analyst::Entities::Class }
      end

      def children
        @ast.children.map do |child_node|
          Analyst::Parser.process_node(child_node, self)
        end
      end

      def full_name
        ""
      end

    end
  end
end

