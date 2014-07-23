# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'projectionist/version'

Gem::Specification.new do |spec|
  spec.name          = 'projectionist'
  spec.version       = Projectionist::VERSION
  spec.authors       = ['Griffin Smith']
  spec.email         = ['wildgriffin45@gmail.com']
  spec.summary       = 'Command line interface to the .projections.json format'
  spec.description   = <<-EOF
    Projectionist allows you to quickly edit files in a project from the command
    line, using the projections.json format
  EOF
  spec.homepage      = 'http://github.com/glittershark/projectionist'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rspec',  '~> 3.0'
  spec.add_development_dependency 'fivemat', '~> 1.3'

  spec.add_runtime_dependency 'thor', '~> 0.19.1', '>= 0.19'
end
