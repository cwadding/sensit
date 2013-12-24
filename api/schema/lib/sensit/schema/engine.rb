module Sensit
	module Schema
		class Engine < ::Rails::Engine
			# config.autoload_paths << File.expand_path("../../../app/controllers/concerns", __FILE__)
			isolate_namespace Sensit
			engine_name "sensit_schema"
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

			config.to_prepare do
				::Sensit::Topic.send :include, ::Schematic
				::Sensit::Topic::Feed.send :include, ::ParentSchematic
				::Sensit::FeedsController.send :include, ::StrongFeedWithFieldParameters
				::Sensit::DataController.send :include, ::StrongDataWithFieldParameters
				::Sensit::Topic::Feed::Importer.send :include, ::FilteredImporter
			end
			
		end
	end
end
