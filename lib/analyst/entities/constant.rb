module Analyst

  module Entities
    class Constant < Entity

      handles_node :const

      def name
        const_node_array(ast).join("::")
      end

      def full_name
        name
      end

      def constants
        []
      end

      private

      # takes a (const) node and returns an array specifying the fully-qualified
      # constant name that it represents.  ya know, so CoolModule::SubMod::SweetClass
      # would be parsed to:
      # (const
      #   (const
      #     (const nil :CoolModule) :SubMod) :SweetClass)
      # and passing that node here would return [:CoolModule, :SubMod, :SweetClass]
      # TODO: should really be nested Entities::Constants all the way down.
      # ((cbase) can probably use the same Entity, or maybe it's a subclass of Constant)
      #
      # Note: if any node besides (const) or (cbase) is encountered, that part gets named
      # '<`source`>' where source is the source code for that node.
      # e.g. `@thing.class::Sub::Mod` parses to:
      # (const
      #   (const
      #     (send
      #       (ivar :@thing) :class) :Sub) :Mod)
      # and the corresponding Entities::Constant gets named "<`@thing.class`>::Sub::Mod"
      def const_node_array(node)
        return [] if node.nil?
        return [''] if node.type == :cbase
        return ["<`#{node.location.expression.source}`>"] unless node.type == :const
        const_node_array(node.children.first) << node.children[1]
      end

    end
  end
end

