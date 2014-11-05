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


    def self.for_files(path_to_files)
      file_paths = if File.directory?(path_to_files)
        Dir.glob(File.join(path_to_files, "**", "*.rb"))
      else
        [path_to_files]
      end

      wrapped_asts = file_paths.map do |path|
        ast = ::Parser::CurrentRuby.parse(File.open(path, 'r').read)
        ::Parser::AST::Node.new(:analyst_file, [ast])
      end

      root_node = ::Parser::AST::Node.new(:analyst_root, wrapped_asts)
      root = Entities::Root.new(root_node, file_paths)
      new(root)
    end

    def self.for_source(source)
      ast = ::Parser::CurrentRuby.parse(source)
      wrapped_ast = ::Parser::AST::Node.new(:analyst_source, [ast])
      root_node = ::Parser::AST::Node.new(:analyst_root, [wrapped_ast])
      root = Entities::Root.new(root_node, [source])
      new(root)
    end

    def initialize(root)
      @root = root
    end

    def inspect
      "\#<#{self.class}:#{object_id}>"
    end

    def source_for(entity)
      #TODO: implement me
    end

    private

    attr_reader :root

  end

end
