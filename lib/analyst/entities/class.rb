#TODO add == to association

module Analyst

  module EntityParser
    module Entities
      class ActiveModel < Entity

        ASSOCIATIONS = [:belongs_to, :has_one, :has_many, :has_and_belongs_to_many]

        attr_reader :associations

        def initialize
          @associations = []
        end

        def handle_send(node)
          target, method_name, *args = node.children
          if ASSOCIATIONS.include?(method_name)
            add_association(method_name, args)
          end
        end

        # When a class is reopened, merge its associations
        def merge_associations_from(klass)
          klass.associations.each do |association|
            associations << Association.new(
              type: association.type,
              source: self,
              target_class: association.target_class
            )
          end
          associations.uniq!
        end

        def name
          const_node_array(ast.children.first).join('::')
        end

        def full_name
          parent.full_name.empty? ? name : parent.full_name + '::' + name
        end

        private

        def add_association(method_name, args)
          target_class = value_from_hash_node(args.last, :class_name)
          target_class ||= begin
                             symbol_node = args.first
                             symbol_name = symbol_node.children.first
                             symbol_name.pluralize.classify
                           end
          association = Association.new(type: method_name, source: self, target_class: target_class)
          associations << association
        end

        private

        # takes a (const) node and returns an array specifying the fully-qualified
        # constant name that it represents.  ya know, so CoolModule::SubMod::SweetClass
        # would be parsed to:
        # (const
        #   (const
        #     (const nil :CoolModule) :SubMod) :SweetClass)
        # and passing that node here would return [:CoolModule, :SubMod, :SweetClass]
        def const_node_array(node)
          return [] if node.nil?
          raise "expected (const) node or nil, got (#{node.type})" unless node.type == :const
          const_node_array(node.children.first) << node.children[1]
        end

        # Fetches value from hash node iff key is symbol and value is str
        # Raises an exception if value is not str
        # Returns nil if key is not found
        def value_from_hash_node(node, key)
          return unless node.type == :hash
          pair = node.children.detect do |pair_node|
            key_symbol_node = pair_node.children.first
            key == key_symbol_node.children.first
          end
          if pair
            value_node = pair.children.last
            throw "Bad type. Expected (str), got (#{value_node.type})" unless value_node.type == :str
            value_node.children.first
          end
        end

      end

    end
  end
end
