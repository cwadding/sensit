require 'sensit/core'
require 'sensit_percolator'
require 'sensit_messenger'

module Sensit
	module Publications
		class Engine < ::Rails::Engine
			isolate_namespace Sensit
			engine_name "sensit_subscriptions"
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
				::Sensit::Topic.send :include, ::PublicationsTopic
				::Sensit::Topic::Feed.send :include, ::Publishable
				::Sensit::Topic::Percolator.send :include, ::Percolatable
			end

			config.view_versions = [1]
			config.view_version_extraction_strategy = :http_header
			config.default_version = 1			
		end
	end
end