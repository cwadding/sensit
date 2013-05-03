# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensit/version'

Gem::Specification.new do |spec|
  spec.name          = "sensit"
  spec.version       = Sensit::VERSION
  spec.authors       = ["Chris Waddington"]
  spec.email         = ["cwadding@gmail.com"]
  spec.description   = "Sensit is an open source realtime data brokerage framework (Internet of Things) for Ruby on Rails."
  spec.summary       = "Open source Internet of Things framework for ruby on rails."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sensit_core", Sensit::VERSION
  spec.add_dependency "sensit_api", Sensit::VERSION
  spec.add_dependency "sensit_frontend", Sensit::VERSION

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'#, '~> 2.10.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
