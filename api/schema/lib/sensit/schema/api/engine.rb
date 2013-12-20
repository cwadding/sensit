require 'rabl'
require 'versioncake'

module Sensit
	module Schema
		module Api
	  		class Engine < ::Rails::Engine
				isolate_namespace Sensit
				engine_name "sensit_schema_api"
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

				config.view_versions = [1]
				config.view_version_extraction_strategy = :http_header

				# config.to_prepare do
				# 	::Sensit::Topic.send :include, TopicApiKeyConcern
				# end
				
			end
		end
	end
end
