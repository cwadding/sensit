lib = File.expand_path('../../../lib', __FILE__)
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

  s.add_dependency "rails", "~> 4.0.3"
  s.add_dependency 'rabl', '~> 0.9.3'
  s.add_dependency 'versioncake', '~>2.0.0'
  s.add_dependency 'kaminari', '~>0.15.1'
  s.add_dependency 'foreigner', '~>1.6.0'  
  s.add_dependency 'rubyzip', '~> 1.1.0'
  s.add_dependency "elasticsearch", "~> 1.0.0"
  s.add_dependency 'roo', "~> 1.13.2"
  s.add_dependency 'friendly_id', '~> 5.0.3'
  s.add_dependency 'doorkeeper', '~> 1.0.0'
  s.add_dependency 'devise', '~> 3.2.3'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'#, '~> 2.10.0'
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "json_spec"
  s.add_development_dependency "oauth2"
  s.add_development_dependency 'simplecov'
end
