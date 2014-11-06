require_relative 'entities/unhandled'

module Analyst

  module Processor

    PROCESSORS = Hash.new(Analyst::Entities::Unhandled)

    def self.register_processor(type, processor)
      if PROCESSORS.key? type
        raise "(#{type}) nodes already registered by #{PROCESSORS[type]}"
      end
      PROCESSORS[type] = processor
    end

    def self.process_node(node, parent)
      return if node.nil?
      return unless node.respond_to?(:type)
      PROCESSORS[node.type].new(node, parent)
    end

  end

end

