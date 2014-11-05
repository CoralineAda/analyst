module Analyst

  module Entities
    class SingletonClass < Entity

      handles_node :sclass

      def full_name
        parent.full_name + "!SINGLETON"
      end

      def name
        parent.name + "!SINGLETON"
      end

      def smethods
        @smethods ||= contents.select { |entity| entity.is_a? Analyst::Entities::InstanceMethod }
      end

    end
  end

end
