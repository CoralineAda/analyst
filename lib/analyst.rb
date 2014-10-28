require 'ephemeral'
require 'poro_plus'
require 'fileutils'
require 'haml'

require_relative "analyst/analyzer"
require_relative "analyst/cli"
require_relative "analyst/context_stack"
require_relative "analyst/entities/entity"
require_relative "analyst/entities/empty"
require_relative "analyst/entities/method"
require_relative "analyst/entities/class"
require_relative "analyst/entities/root"
require_relative "analyst/formatters/base"
require_relative "analyst/formatters/csv"
require_relative "analyst/formatters/html"
require_relative "analyst/formatters/html_index"
require_relative "analyst/formatters/text"
require_relative "analyst/line_of_code"
require_relative "analyst/parsed_file"
require_relative "analyst/parsed_method"
require_relative "analyst/parser"
require_relative "analyst/version"

module Analyst
  def self.new(path_to_files)
    Analyst::Parser.new(FileProcessor.new(path_to_files).ast)
  end

  class FileProcessor

    attr_reader :path_to_files

    def initialize(path_to_files)
      @path_to_files = path_to_files
    end

    def source_files
      if File.directory?(path_to_files)
        return Dir.glob(File.join(path_to_files, "**", "*.rb"))
      else
        return [path_to_files]
      end
    end

    def ast
      root_node = ::Parser::AST::Node.new(
        :root, source_files.map do |file|
          content = File.open(file, "r").read
          ::Parser::CurrentRuby.parse(content)
        end
      )
    end

  end

end
