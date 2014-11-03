module Analyst
  module Entities
    class Module < Entity

      def kind
        "Module"
      end

      def name
        const_node_array(name_node).join('::')
      end

      def full_name
        parent.full_name.empty? ? name : parent.full_name + '::' + name
      end

      private

      def name_node
        ast.children.first
      end

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
