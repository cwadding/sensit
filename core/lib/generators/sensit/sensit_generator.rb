class SensitGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

	def install_core
		generate "sensit:core:install"
	end

	# def install_percolator
	# 	generate "sensit:percolator:install"  if defined?(Sensit::Percolator::Engine)
	# end

	# def install_reports
	# 	generate "sensit:reports:install" if defined?(Sensit::Reports::Engine)
	# end

	# def install_schema
	# 	generate "sensit:schema:install"  if defined?(Sensit::Schema::Engine)
	# end

	# def install_subscriptions
	# 	generate "sensit:subscriptions:install"  if defined?(Sensit::Subscriptions::Engine)
	# end

	# def install_security
	# 	generate "sensit:security:install"  if defined?(Sensit::Security::Engine)
	# end

	# def install_unit_conversion
	# 	generate "sensit:unit_conversion:install"  if defined?(Sensit::UnitConversion::Engine)
	# end	

end
