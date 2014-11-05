module Analyst

  module Entities
    class Symbol < Entity

      handles_node :sym

      def value
        ast.children.first
      end

      def name
      end

      def full_name
      end

     private

      def content_node
      end

    end
  end
end

