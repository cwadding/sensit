class Sensit::Core::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  	def devise_install
		generate "devise:install"
		generate "devise Sensit::User"
  	end

  	def doorkeeper_install
		generate "doorkeeper:install"
		generate "doorkeeper:migration"
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

end
