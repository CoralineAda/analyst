module Analyst

  module Entities
    module Begin

      def self.new(node, parent)
        node.children.map { |child| Analyst::Parser.process_node(child, parent) }
      end

    end
  end
end

