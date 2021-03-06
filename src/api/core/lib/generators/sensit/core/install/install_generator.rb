class Sensit::Core::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  # 	def devise_install
		# generate "devise:install"
		# generate "devise Sensit::User"
  # 	end

  # 	def doorkeeper_install
		# generate "doorkeeper:install"
		# generate "doorkeeper:migration"
		# # generate "doorkeeper:application_owner"
  # 	end

	def install_migrations
		say_status :copying, "migrations"
		rake 'railties:install:migrations'
	end

	# def add_core_engine_routes
	# 	route "mount Sensit::Core::Engine => \"/\""
	# end

	# def inject_sensible_owner
	# 	content = "  include ::SensibleOwner\n"
	# 	inject_into_class("app/models/sensit/user.rb", "Sensit::User", content)
	# end

	# def use_custom_oauth_applications_controller
	# 	gsub_file("config/routes.rb", "use_doorkeeper", "use_doorkeeper do\n\t\tcontrollers :applications => 'oauth/applications'\n\tend")
	# end	

	# def uncomment_enable_application_owner
	# 	gsub_file("config/initializers/doorkeeper.rb", "# enable_application_owner :confirmation => false", "enable_application_owner :confirmation => true")
	# end

	# def gsub_resource_owner_authenticator
	# 	gsub_file("config/initializers/doorkeeper.rb", /resource_owner_authenticator do(\s+)(.+)(\s+)(.+)(\s+)(.+)(\s+)(.+)/, "resource_owner_authenticator do\n\t\tSensit::User.find_by_id(session[:user_id]) || redirect_to(new_user_session_url)")
	# end

	# def inject_into_application_controller
	# 	content = "\tbefore_filter :configure_permitted_parameters, if: :devise_controller?\n\n\tprotected\n\n\tdef configure_permitted_parameters\n\t\tdevise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }\nend\n"
	# 	# \t\tdevise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }\n\t\tdevise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }\n\t
	# 	inject_into_class("app/controllers/application_controller.rb", "ApplicationController", content)
	# end

	# def add_default_scopes
	#  	gsub_file("config/initializers/doorkeeper.rb", "# default_scopes  :public", "default_scopes :read_application_data, :manage_application_data")
	# end
	# def add_optional_scopes
	#  	gsub_file("config/initializers/doorkeeper.rb", "# optional_scopes :write, :update", "optional_scopes :read_any_data, :manage_any_data, :read_any_percolations, :manage_any_percolations, :read_application_percolations, :manage_application_percolations, :read_any_publications, :manage_any_publications, :read_application_publications, :manage_application_publications, :read_any_subscriptions, :manage_any_subscriptions, :read_application_subscriptions, :manage_application_subscriptions, :read_any_publications, :manage_any_publications, :read_application_publications, :manage_application_publications")
	# end	


end
