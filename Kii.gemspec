# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'Kii/version'

Gem::Specification.new do |spec|
  spec.name          = "Kii"
  spec.version       = Kii::VERSION
  spec.authors       = ["Arda Karaduman"]
  spec.email         = ["akaraduman@gmail.com"]
  spec.description   = %q{Ruby library to access Kii Cloud}
  spec.summary       = %q{Ruby library to access Kii Cloud}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "lib/Kii"]

  spec.add_dependency "rest-client", "~> 1.6"
  spec.add_dependency "json", "~> 1.8"
  spec.add_dependency "dotenv"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "pry-debugger"
end
