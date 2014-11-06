require 'fileutils'

module Analyst

  class Parser

    extend Forwardable

    def_delegators :root, :classes, :top_level_classes, :constants,
                          :methods

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

    def top_level_entities
      root.contents
    end

    private

    attr_reader :root

  end

end
