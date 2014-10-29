# An entity is a named node of a given type which may have additional properties
module Analyst
  module Entities
    class Entity

      attr_reader :parent

      def initialize(ast, parent)
        @parent = parent
        @ast = ast
      end

      def handle_send_node(node)
        # raise "Subclass must implement handle_send_node"
        # abstract method.  btw, this feels wrong -- send should be an entity too.  but for now, whatevs.
      end

      # TODO: should every Entity have these accessors? maybe they're mixins... but would that provide any benefit?
      def classes
        @classes ||= begin
          nested_classes = top_level_classes.map(&:classes).flatten
          namespaced_classes = top_level_modules.map(&:classes).flatten
          top_level_classes + nested_classes + namespaced_classes
        end
      end

      def top_level_modules
        @top_level_modules ||= contents.select { |entity| entity.is_a? Analyst::Entities::Module }
      end

      def top_level_classes
        @top_level_classes ||= contents.select { |entity| entity.is_a? Analyst::Entities::Class }
      end




      def full_name
        throw "Subclass #{self.class.name} must implement #full_name"
      end

      def inspect
        "\#<#{self.class}:#{object_id} full_name=#{full_name}>"
      rescue
        "\#<#{self.class}:#{object_id}>"
      end

      private

      attr_reader :ast

      def contents
        @contents ||= Array(Analyst::Parser.process_node(content_node, self))
      end

      def content_node
        ast.children.last
      end

    end
  end
end
