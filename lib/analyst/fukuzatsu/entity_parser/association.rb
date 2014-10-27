module Analyst

  module EntityParser

    class ClassRelation
      attr_reader :type, :source, :target_class_name, :target

      def initialize(type:, source:, target_class_name:)
        @type = type
        @source = source
        @target_class_name = target_class_name
      end

      def resolve_target!(entity_list)
        unless @target = entity_list.detect{ |entity| entity.full_name == self.target_class_name }
          puts "WARNING: Couldn't find target: #{self.target_class_name}"
        end
      end

    end

  end
end

