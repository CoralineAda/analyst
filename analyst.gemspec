# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'analyst/version'

Gem::Specification.new do |spec|
  spec.name          = "analyst"
  spec.version       = Analyst::VERSION
  spec.authors       = ["Coraline Ada Ehmke", "Mike Ziwisky"]
  spec.email         = ["coraline@idolhands.com", "mikezx@gmail.com"]
  spec.summary       = %q{A nice API for interacting with parsed Ruby source code.}
  spec.description   = %q{A nice API for interacting with parsed Ruby source code.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "haml"
  spec.add_dependency "parser"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "flog"

end

