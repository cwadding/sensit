# require 'sensit_core'
module Sensit
	module Retention
		class Engine < ::Rails::Engine
			isolate_namespace Sensit
			engine_name "sensit_retention"
			config.generators do |g|
				g.test_framework :rspec, :fixture => false
				g.fixture_replacement :factory_girl, :dir => 'spec/factories'
				g.assets false
				g.helper false
			end

			# Rabl.configure do |config|
			# 	config.include_json_root = false
			# 	config.include_child_root = false
			# end

			# config.to_prepare do
			# 	::Sensit::Topic.send :include, ::RetentionConfigurable
			# 	::Sensit::Topic::Fedd.send :include, ::Expirable
			# end

			# config.view_versions = [1]
			# config.view_version_extraction_strategy = :http_header

			
		end
	end
end
