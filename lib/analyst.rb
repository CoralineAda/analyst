require 'fileutils'
require 'haml'
require 'parser/current'

require_relative "analyst/parser"
require_relative "analyst/processor"
require_relative "analyst/version"
require_relative "analyst/entities/entity"
require_relative "analyst/entities/root"
require_relative "analyst/entities/file"
require_relative "analyst/entities/source"
require_relative "analyst/entities/code_block"
require_relative "analyst/entities/module"
require_relative "analyst/entities/class"
require_relative "analyst/entities/interpolated_string"
require_relative "analyst/entities/constant"
require_relative "analyst/entities/conditional"
require_relative "analyst/entities/method"
require_relative "analyst/entities/method_call"
require_relative "analyst/entities/singleton_class"
require_relative "analyst/entities/array"
require_relative "analyst/entities/hash"
require_relative "analyst/entities/pair"
require_relative "analyst/entities/symbol"
require_relative "analyst/entities/string"

module Analyst

  module ClassMethods

    def for_files(path_to_files)
      Analyst::Parser.for_files(path_to_files)
    end

    alias :for_file :for_files

    def for_source(source)
      Analyst::Parser.for_source(source)
    end

  end

  extend ClassMethods

end
