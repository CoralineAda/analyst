module Analyst
  module Entities
    class Module < Entity

      handles_node :module

      def kind
        "Module"
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
