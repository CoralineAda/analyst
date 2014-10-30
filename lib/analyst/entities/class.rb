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

    end

  end
end
