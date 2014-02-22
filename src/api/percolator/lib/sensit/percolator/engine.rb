require 'sensit/core'
module Sensit
	module Percolator
		class Engine < ::Rails::Engine
			isolate_namespace Sensit
			engine_name "sensit_percolator"
			config.generators do |g|
				g.test_framework :rspec, :fixture => false
				g.fixture_replacement :factory_girl, :dir => 'spec/factories'
				g.assets false
					g.helper false
			end

			Rabl.configure do |config|
				config.include_json_root = false
				config.include_child_root = false
			end

			config.to_prepare do
				::Sensit::Topic.send :include, ::Sensit::Percolatable
			end

			config.versioncake.supported_version_numbers = [1]
			config.versioncake.extraction_strategy = :http_header
			config.versioncake.default_version = 1
		end
	end
end
