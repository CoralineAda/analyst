module Analyst

  module Entities
    class Root < Entity

      def classes
        @classes ||= children.select { |child| child.is_a? Analyst::Entities::Class }
      end

      def full_name
        ""
      end

    end
  end
end

