module Analyst

  module EntityParser
    module Entities
      class Module < Entity
        def name
          const_node_array(ast.children.first).join('::')
        end
        def full_name
          parent.full_name.empty? ? name : parent.full_name + '::' + name
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
      end
    end
  end

end
