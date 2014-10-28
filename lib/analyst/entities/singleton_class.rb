module Analyst

  module Entities
    class SingletonClass < Entity

      def full_name
        parent.full_name + "!SINGLETON"
      end

      def name
        parent.name + "!SINGLETON"
      end

      def smethods
        @smethods ||= children.select { |child| child.is_a? Analyst::Entities::InstanceMethod }
      end

    end
  end

end
