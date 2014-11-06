#TODO add == to association
# TODO look thru the singleton_methods for ones on (self),
#   and also look for the ones from 'class << self' constructs, which will be
#   found in (sclass) nodes (which will be some sort of Entity)

module Analyst

  module Entities
    class Class < Analyst::Entities::Module

      handles_node :class

      alias :macros :method_calls

      def kind
        "Class"
      end

      def singleton_class_blocks
        contents.select { |entity| entity.is_a? Analyst::Entities::SingletonClass }
      end

    end

  end
end
