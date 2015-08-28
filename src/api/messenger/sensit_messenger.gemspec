# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensit_messenger/version'

Gem::Specification.new do |spec|
  spec.name          = "sensit_messenger"
  spec.version       = Sensit::Messenger::VERSION
  spec.authors       = ["Chris Waddington"]
  spec.email         = ["cwadding@gmail.com"]
  spec.summary       = "A combination of a bunch of publish and/or subscribe protocols"
  spec.description   = "A combination of a bunch of publish and/or subscribe protocols"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'mqtt'
  spec.add_dependency 'eventmachine'
  spec.add_dependency 'amqp'
  spec.add_dependency 'blather'
  # https://github.com/ruby-amqp/amqp
  
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency 'rspec'#, '~> 2.10.0'
end
