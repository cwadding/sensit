require 'sensit/core'
require 'ruby-units'
module Sensit
	module UnitConversion
		class Engine < ::Rails::Engine
			isolate_namespace Sensit
			engine_name "sensit_unit_conversion"
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

			config.versioncake.supported_version_numbers = [1]
			config.versioncake.extraction_strategy = :http_header
			config.versioncake.default_version = 1

			config.to_prepare do
				::Sensit::Topic::Field.send :include, ::Sensit::Measurable
				::Sensit::Topic::Feed.send :include, ::Sensit::Convertable
			end
		end
	end
end
