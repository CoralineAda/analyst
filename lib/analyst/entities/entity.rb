# An entity is a named node of a given type which may have additional properties
module Analyst
  module Entities
    class Entity

      attr_reader :parent

      def initialize(ast, parent)
        @parent = parent
        @ast = ast
      end

      def children
        @children ||= []
      end

      def handle_send_node(node)
        # raise "Subclass must implement handle_send_node"
        # abstract method.  btw, this feels wrong -- send should be an entity too.  but for now, whatevs.
      end

      def full_name
        throw "Subclass must implement #full_name"
      end

      def inspect
        "\#<#{self.class}:#{object_id} full_name=#{full_name}>"
      end

    end
  end
end
