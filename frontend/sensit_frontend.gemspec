lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensit/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sensit_frontend"
  s.version     = Sensit::VERSION
  s.authors     = ["Chris Waddington"]
  s.email       = ["cwadding@gmail.com"]
  s.summary     = "A rails engine containing the frontend interface for Sensit; an open source realtime data brokerage platform for the Internet of Things."
  s.description = "A rails engine containing the frontend interface for Sensit; an open source realtime data brokerage platform for the Internet of Things."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'sensit_core', Sensit::VERSION

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'#, '~> 2.10.0'
  s.add_development_dependency "factory_girl_rails"

end
