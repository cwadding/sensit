module Sensit
	module Core
		class Engine < ::Rails::Engine
			isolate_namespace Sensit
			engine_name 'sensit'
			config.generators do |g|
				g.test_framework :rspec, :view_specs => false
			end
		end
	end
end