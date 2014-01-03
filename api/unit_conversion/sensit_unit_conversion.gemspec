$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sensit_unit_conversion/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sensit_unit_conversion"
  s.version     = SensitUnitConversion::VERSION
  s.authors     = ["Chris Waddington"]
  s.email       = ["cwadding@gmail.com"]
  # s.homepage    = "TODO"
  s.summary     = "Summary of SensitUnitConversion."
  s.description = "Description of SensitUnitConversion."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'sensit_core', Sensit::VERSION
  s.add_dependency 'ruby-units', "~> 1.4.4"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "json_spec"
  s.add_development_dependency "factory_girl_rails"
end
