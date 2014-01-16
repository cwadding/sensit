require_dependency "sensit/api_controller"

module Sensit
	class SessionsController < ApiController
		def create
			user = User.find_by_name(params[:name])
			if user && user.authenticate(params[:password])
				session[:user_id] = user.id
				if session[:return_to]
					redirect_to session[:return_to]
					session[:return_to] = nil
				else
					head :status => :created
				end
			else
				head :status => :bad_request
			end
		end

		def destroy
			session[:user_id] = nil
			head :status => :no_content
		end
	end
end
