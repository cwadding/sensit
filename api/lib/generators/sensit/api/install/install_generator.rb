class Sensit::Api::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  	def install_migrations
		say_status :copying, "migrations"
		rake 'railties:install:migrations'
	end
end
