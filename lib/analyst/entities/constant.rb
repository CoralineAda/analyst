module Analyst

  module Entities
    class Constant < Entity

      def name
        binding.pry
        const_node_array(ast).join("::")
      end

      def full_name
        name
      end

      def constants
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

