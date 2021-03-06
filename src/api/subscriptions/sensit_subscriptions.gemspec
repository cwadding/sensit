lib = File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensit/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sensit_subscriptions"
  s.version     = Sensit::VERSION
  s.authors     = ["Chris Waddington"]
  s.email       = ["cwadding@gmail.com"]
  s.summary     = "A rails engine containing the application interface for Sensit; an open source realtime data brokerage platform for the Internet of Things."
  s.description = "A rails engine containing the application interface for Sensit; an open source realtime data brokerage platform for the Internet of Things."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]


  s.add_dependency 'sensit_core', Sensit::VERSION 
  s.add_dependency 'sensit_messenger', '0.0.1'
  # s.add_dependency 'em-websocket'# , '0.0.3'
  s.add_dependency 'socketio-client'# , '0.0.3'
  s.add_dependency 'faye', '1.0.0'
  s.add_dependency 'eventmachine'
  s.add_dependency 'mqtt'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "json_spec"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency 'shoulda-matchers'#, '~> 2.10.0'
  s.add_development_dependency "oauth2"
  s.add_development_dependency 'simplecov'
end
