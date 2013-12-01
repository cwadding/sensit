lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensit/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sensit_api"
  s.version     = Sensit::VERSION
  s.authors     = ["Chris Waddington"]
  s.email       = ["cwadding@gmail.com"]
  s.summary     = "A rails engine containing the application interface for Sensit; an open source realtime data brokerage platform for the Internet of Things."
  s.description = "A rails engine containing the application interface for Sensit; an open source realtime data brokerage platform for the Internet of Things."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]


  s.add_dependency 'sensit_core', Sensit::VERSION
  s.add_dependency 'rabl', '0.8.4'
  s.add_dependency 'versioncake', '1.0.0'
  s.add_dependency 'sidekiq', '2.17.0'  
  s.add_dependency 'socketio-client', '0.0.3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "json_spec"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency 'capybara'#, '~> 2.10.0'

end
