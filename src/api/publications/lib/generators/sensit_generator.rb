class SensitGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

	def install_core
		generate "sensit:publications:install"
	end
end
