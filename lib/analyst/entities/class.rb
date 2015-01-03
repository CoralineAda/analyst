module Analyst
  module Entities
    class Class < Entity

      include HasMethods

      handles_node :class

      alias :macros :method_calls

      def kind
        "Class"
      end

      def singleton_class_blocks
        contents.select { |entity| entity.is_a? Analyst::Entities::SingletonClass }
      end

      def name
        name_entity.name
      end

      def full_name
        parent.full_name.empty? ? name : parent.full_name + '::' + name
      end

      private

      def name_entity
        @name_entity ||= process_node(name_node)
      end

      def name_node
        ast.children.first
      end
    end
  end
end

