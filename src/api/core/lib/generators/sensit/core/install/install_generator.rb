class Sensit::Core::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  	def devise_install
		generate "devise:install"
		generate "devise Sensit::User"
  	end

  	def doorkeeper_install
		generate "doorkeeper:install"
		generate "doorkeeper:migration"
		generate "doorkeeper:application_owner"
  	end

	def install_migrations
		say_status :copying, "migrations"
		rake 'railties:install:migrations'
	end

	def add_core_engine_routes
		route "mount Sensit::Core::Engine => \"/\""
	end

	def inject_sensible_owner
		content = "  include ::SensibleOwner\n"
		inject_into_class("app/models/sensit/user.rb", "Sensit::User", content)
	end

	def use_custom_oauth_applications_controller
		gsub_file("config/routes.rb", "use_doorkeeper", "use_doorkeeper do\n\t\tcontrollers :applications => 'oauth/applications'\n\tend")
	end	

	def uncomment_enable_application_owner
		gsub_file("config/initializers/doorkeeper.rb", "# enable_application_owner :confirmation => false", "enable_application_owner :confirmation => false")
	end

	def gsub_resource_owner_authenticator
		gsub_file("config/initializers/doorkeeper.rb", /resource_owner_authenticator do(\s+)(.+)(\s+)(.+)(\s+)(.+)(\s+)(.+)/, "resource_owner_authenticator do\n\t\tSensit::User.find_by_id(session[:user_id]) || redirect_to(new_user_session_url)")
	end

end
