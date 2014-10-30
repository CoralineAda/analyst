module Analyst

  module Entities
    class Symbol < Entity

      def value
        node.children.first
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

