module Analyst

  module Entities
    class String < Entity

      def value
        node.children.first
      end

      private

      def content_node
      end

    end
  end
end

