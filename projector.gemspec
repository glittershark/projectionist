# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'projector/version'

Gem::Specification.new do |spec|
  spec.name          = 'projector'
  spec.version       = Projector::VERSION
  spec.authors       = ['Griffin Smith']
  spec.email         = ['wildgriffin45@gmail.com']
  spec.summary       = 'Command line interface to the .projections.json format'
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = 'http://github.com/glittershark/projector'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'fivemat'

  spec.add_runtime_dependency 'thor', '~> 0.19.1', '>= 0.19'
end
