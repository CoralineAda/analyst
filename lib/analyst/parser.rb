module Analyst

  class Parser

    extend Forwardable

    def_delegators :root, :classes, :top_level_classes, :constants,
                          :methods, :method_calls, :hashes

    def self.for_files(*path_to_files)
      file_paths = path_to_files.map do |path|
        if File.directory?(path)
          Dir.glob(File.join(path, "**", "*.rb"))
        else
          path
        end
      end.flatten

      asts = file_paths.map do |path|
        File.open(path) do |file|
          parse_source(file.read, path)
        end
      end.compact

      new(asts)
    end

    def self.for_source(source)
      ast = parse_source(source)
      new([ast].compact)
    end

    def self.parse_source(source, filename='(string)')
      parser = ::Parser::CurrentRuby.new
      parser.diagnostics.all_errors_are_fatal = true
      parser.diagnostics.ignore_warnings      = true

      buffer = ::Parser::Source::Buffer.new(filename)
      buffer.source = source
      parser.parse(buffer)
    rescue ::Parser::SyntaxError => e
      $stderr.puts "Error during parsing; #{filename == '(string)' ? 'string' : 'file'} will be skipped:"
      $stderr.puts format_diagnostic_msg(e.diagnostic)
    end
    private_class_method :parse_source

    def self.format_diagnostic_msg(diagnostic)
      diagnostic.render.map { |line| "  #{line}" }.join("\n")
    end
    private_class_method :format_diagnostic_msg

    def initialize(asts)
      root_node = ::Parser::AST::Node.new(:analyst_root, asts)
      @root = Processor.process_node(root_node, nil)
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
