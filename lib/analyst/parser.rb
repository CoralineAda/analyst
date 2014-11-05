require 'fileutils'
require_relative 'entities/unhandled'

module Analyst

  class Parser

    extend Forwardable

    attr_reader :start_path

    def_delegators :root, :classes, :top_level_classes, :constants,
                          :methods

    PROCESSORS = Hash.new(Entities::Unhandled)

    def self.register_processor(type, processor)
      raise "(#{type}) nodes already registered by #{PROCESSORS[type]}" if PROCESSORS.key? type
      PROCESSORS[type] = processor
    end

    def self.process_node(node, parent)
      return if node.nil?
      return unless node.respond_to?(:type)
      PROCESSORS[node.type].new(node, parent)
    end

    def initialize(ast)
      @ast = ast
    end

    def inspect
      "\#<#{self.class}:#{object_id}>"
    end

    def source_for(entity)
      #TODO: implement me
    end

    private

    def root
      @root ||= self.class.process_node(@ast, nil)
    end

  end

end
