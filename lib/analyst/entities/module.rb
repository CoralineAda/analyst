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

      def imethods
        @imethods ||= contents.select { |entity| entity.is_a? Analyst::Entities::InstanceMethod }
      end

      def cmethods
        some_methods = smethods.select { |method| method.target.type == :self }
        other_methods = singleton_class_blocks { |block| block.target.type == :self }.map(&:smethods).flatten
        some_methods + other_methods
      end

      def all_methods
        cmethods + imethods
      end

      def singleton_class_blocks
        contents.select { |entity| entity.is_a? Analyst::Entities::SingletonClass }
      end

      private

      def smethods
        @smethods ||= contents.select do |entity|
          entity.is_a? Analyst::Entities::SingletonMethod
        end
      end

      def name_entity
        @name_entity ||= process_node(name_node)
      end

      def name_node
        ast.children.first
      end
    end
  end
end
