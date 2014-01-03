require 'rabl'
require 'versioncake'
require 'elasticsearch'
require 'csv'
# require 'iconv'
require 'roo'
require 'zip'
require 'friendly_id'
require 'kaminari'

module Sensit
	module Core
		class Engine < ::Rails::Engine
			isolate_namespace Sensit
			engine_name 'sensit'
			config.generators do |g|
				g.test_framework :rspec, :view_specs => false
				g.fixture_replacement :factory_girl, :dir => 'spec/factories'
				g.assets false
      			g.helper false
			end

			::Rabl.configure do |rabl|
				rabl.include_json_root = false
				rabl.include_child_root = false
			end

			config.view_versions = [1]
			config.view_version_extraction_strategy = :http_header

			# config.to_prepare do
			# 	::Sensit::Topic.send :include, TopicApiKeyConcern
			# end

			::Kaminari.configure do |kaminari|
			  # kaminari.default_per_page = 25
			  # kaminari.max_per_page = nil
			  # kaminari.window = 4
			  # kaminari.outer_window = 0
			  # kaminari.left = 0
			  # kaminari.right = 0
			  # kaminari.page_method_name = :page
			  # kaminari.param_name = :page
			end


		end
	end
end