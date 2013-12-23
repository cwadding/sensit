module Sensit
	module Security
		class Engine < ::Rails::Engine
			isolate_namespace Sensit
			engine_name "sensit_security_api"
			config.generators do |g|
				g.test_framework :rspec, :fixture => false
				g.fixture_replacement :factory_girl, :dir => 'spec/factories'
				g.assets false
				g.helper false
			end

			# config.to_prepare do
			# 	::Sensit::Topic.send :include, ::Sensit::Schematic
			# end
		end
	end
end
