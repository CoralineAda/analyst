require_relative '../parser'

# An entity is a named node of a given type which may have additional properties
module Analyst
  module Entities
    class Entity

      attr_reader :parent

      def self.handles_node(type)
        Analyst::Parser.register_processor(type, self)
      end

      def initialize(ast, parent)
        @parent = parent
        @ast = ast
      end

      def classes
        @classes ||= begin
          nested_classes = top_level_classes.map(&:classes).flatten
          namespaced_classes = top_level_modules.map(&:classes).flatten
          top_level_classes + nested_classes + namespaced_classes
        end
      end

      def constants
        @constants ||= top_level_constants + contents.map(&:constants).flatten
      end

      def top_level_constants
        @top_level_constants ||= contents_of_type(Entities::Constant)
      end

      def top_level_modules
        @top_level_modules ||= contents_of_type(Entities::Module)
      end

      def top_level_classes
        @top_level_classes ||= contents_of_type(Entities::Class)
      end

      def method_calls
        @method_calls ||= contents_of_type(Entities::MethodCall)
      end

      # TODO: rethink the different kinds of Methods. there's really only one
      # kind of Method, right??
      # ref: http://www.devalot.com/articles/2008/09/ruby-singleton
      def methods
        @methods ||= contents_of_type(Entities::InstanceMethod)
      end

      def conditionals
        @conditionals ||= contents_of_type(Entities::Conditional)
      end

      def location
        Range.new(ast.loc.expression.begin_pos, ast.loc.expression.end_pos + 1)
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

      def contents_of_type(klass)
        contents.select { |entity| entity.is_a? klass }
      end

      def contents
        @contents ||= if actual_contents.is_a? Entities::CodeBlock
                        actual_contents.contents
                      else
                        Array(actual_contents)
                      end
      end

      def actual_contents
        @actual_contents ||= process_node(content_node)
      end

      def content_node
        ast.children.last
      end

      def process_node(node, parent=self)
        Analyst::Parser.process_node(node, parent)
      end

      def process_nodes(nodes, parent=self)
        nodes.map { |node| process_node(node, parent) }
      end
    end
  end
end
