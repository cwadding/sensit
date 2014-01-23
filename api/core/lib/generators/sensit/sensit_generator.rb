class SensitGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

	def install_core
		generate "devise:install"
		generate "devise Sensit::User"
		generate "doorkeeper:install"
		generate "doorkeeper:migration"

		say_status :copying, "migrations"
		rake 'railties:install:migrations'
		route "mount Sensit::Core::Engine => \"/\""
		content = "  include SensibleUser\n"
		inject_into_class("app/models/sensit/user.rb", "Sensit::User", content)
	end


	# def inject_model_content 
		# content = model_contents

		# class_path = if namespaced?
		# 	class_name.to_s.split("::")
		# else
		# 	[class_name]
		# end

		# indent_depth = class_path.size - 1
	# 	content = "include SensibleUser\n"

	# 	inject_into_class("sensit/user", User, content) if model_exists?
	# end
end
