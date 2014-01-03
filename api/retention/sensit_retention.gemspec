lib = File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensit/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sensit_retention"
  s.version     = Sensit::VERSION
  s.authors     = ["Chris Waddington"]
  s.email       = ["cwadding@gmail.com"]
  s.summary     = "A rails engine for controlling the retention period of a document."
  s.description = "A rails engine for controlling the retention period of a document."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'sensit_core', Sensit::VERSION
  s.add_dependency 'chronic_duration', "~>0.10.2"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "json_spec"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency 'shoulda-matchers'#, '~> 2.10.0'

end
