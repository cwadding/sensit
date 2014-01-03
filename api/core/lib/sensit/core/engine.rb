require 'rabl'
require 'versioncake'
require 'elasticsearch'
require 'csv'
# require 'iconv'
require 'roo'
require 'zip'
require 'friendly_id'
require 'kaminari'
require 'authority'

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


			::Authority.configure do |config|

			  # USER_METHOD
			  # ===========
			  # Authority needs the name of a method, available in any controller, which
			  # will return the currently logged-in user. (If this varies by controller,
			  # just create a common alias.)
			  #
			  # Default is:
			  #
			  # config.user_method = :current_user

			  # CONTROLLER_ACTION_MAP
			  # =====================
			  # For a given controller method, what verb must a user be able to do?
			  # For example, a user can access 'show' if they 'can_read' the resource.
			  #
			  # These can be modified on a per-controller basis; see README. This option
			  # applies to all controllers.
			  #
			  # Defaults are as follows:
			  #
			  # config.controller_action_map = {
			  #   :index   => 'read',
			  #   :show    => 'read',
			  #   :new     => 'create',
			  #   :create  => 'create',
			  #   :edit    => 'update',
			  #   :update  => 'update',
			  #   :destroy => 'delete'
			  # }

			  # ABILITIES
			  # =========
			  # Teach Authority how to understand the verbs and adjectives in your system. Perhaps you
			  # need {:microwave => 'microwavable'}. I'm not saying you do, of course. Stop looking at
			  # me like that.
			  #
			  # Defaults are as follows:
			  #
			  # config.abilities =  {
			  #   :create => 'creatable',
			  #   :read   => 'readable',
			  #   :update => 'updatable',
			  #   :delete => 'deletable'
			  # }

			  # LOGGER
			  # ======
			  # If a user tries to perform an unauthorized action, where should we log that fact?
			  # Provide a logger object which responds to `.warn(message)`, unless your
			  # security_violation_handler calls a different method.
			  #
			  # Default is:
			  #
			  # config.logger = Logger.new(STDERR)
			  #
			  # Some possible settings:
			  # config.logger = Rails.logger                     # Log with all your app's other messages
			  # config.logger = Logger.new('log/authority.log')  # Use this file
			  # config.logger = Logger.new('/dev/null')          # Don't log at all (on a Unix system)

			end


		end
	end
end