lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensit/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sensit_core"
  s.version     = Sensit::VERSION
  s.authors     = ["Chris Waddington"]
  s.email       = ["cwadding@gmail.com"]
  s.summary     = "A rails engine containing the data models for Sensit an open source realtime data brokerage platform for the Internet of Things."
  s.description = "A rails engine containing the data models for Sensit an open source realtime data brokerage platform for the Internet of Things."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.1"
  s.add_dependency 'rabl', '0.8.4'
  s.add_dependency 'versioncake', '1.0.0'
  
  s.add_dependency 'rubyzip', '~> 1.1.0'
  s.add_dependency "elasticsearch", "~> 0.4.1"
  s.add_dependency 'roo', "~> 1.13.0"
  s.add_dependency 'friendly_id', '~> 5.0.2'
  
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'#, '~> 2.10.0'
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "json_spec"
end
