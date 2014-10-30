#TODO add == to association
# TODO look thru the singleton_methods for ones on (self),
#   and also look for the ones from 'class << self' constructs, which will be
#   found in (sclass) nodes (which will be some sort of Entity)

module Analyst

  module Entities
    class Class < Analyst::Entities::Module

      alias :macros :method_calls

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

      # ASSOCIATIONS = [:belongs_to, :has_one, :has_many, :has_and_belongs_to_many]

      # attr_reader :associations

      # def initialize(node, parent)
      #   @associations = []
      #   super
      # end

      # def handle_send(node)
      #   target, method_name, *args = node.children
      #   if ASSOCIATIONS.include?(method_name)
      #     add_association(method_name, args)
      #   end
      # end

      # # When a class is reopened, merge its associations
      # def merge_associations_from(klass)
      #   klass.associations.each do |association|
      #     associations << Association.new(
      #       type: association.type,
      #       source: self,
      #       target_class: association.target_class
      #     )
      #   end
      #   associations.uniq!
      # end

      # private

      # def add_association(method_name, args)
      #   target_class = value_from_hash_node(args.last, :class_name)
      #   target_class ||= begin
      #                      symbol_node = args.first
      #                      symbol_name = symbol_node.children.first
      #                      symbol_name.pluralize.classify
      #                    end
      #   association = Association.new(type: method_name, source: self, target_class: target_class)
      #   associations << association
      # end

      # private

      # # Fetches value from hash node iff key is symbol and value is str
      # # Raises an exception if value is not str
      # # Returns nil if key is not found
      # def value_from_hash_node(node, key)
      #   return unless node.type == :hash
      #   pair = node.children.detect do |pair_node|
      #     key_symbol_node = pair_node.children.first
      #     key == key_symbol_node.children.first
      #   end
      #   if pair
      #     value_node = pair.children.last
      #     throw "Bad type. Expected (str), got (#{value_node.type})" unless value_node.type == :str
      #     value_node.children.first
      #   end
      # end

    end

  end
end
