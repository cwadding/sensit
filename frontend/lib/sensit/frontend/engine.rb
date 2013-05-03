module Sensit
	module Frontend
		class Engine < ::Rails::Engine
			isolate_namespace Sensit
			engine_name 'sensit_frontend'
			config.generators do |g|
				g.test_framework :rspec, :view_specs => false, :fixture => false
				g.fixture_replacement :factory_girl, :dir => 'spec/factories'
			end
		end
	end
end
