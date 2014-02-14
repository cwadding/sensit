class ApplicationController < ActionController::Base

	# force_ssl
	after_filter :store_location

	before_filter :configure_permitted_parameters, if: :devise_controller?

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
	end  # Prevent CSRF attacks by raising an exception.
  
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def store_location
		if params.has_key?(:return_to)
			session[:return_to] = params[:return_to]
		end
	end

	def after_sign_in_path_for(resource)
		redirect = session[:return_to]
		session[:return_to] = nil
		redirect || root_path
	end
end
