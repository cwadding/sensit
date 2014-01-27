class Sensit::Schema::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
	def install_core
		generate "sensit:core:install"
	end
end
