module Sensit
	class ApiController < ActionController::Base

		# force_ssl

		def current_user
			if doorkeeper_token
				@current_user ||= ::Sensit::User.find(doorkeeper_token.resource_owner_id)
			end
		end

		def current_application
			if doorkeeper_token
				@current_application ||= ::Doorkeeper::Application.find(doorkeeper_token.application_id)
			end
		end

		# def user_id
		# 	doorkeeper_token ? doorkeeper_token.resource_owner_id : session[:user_id]
		# end

		def elastic_index_name
			current_user.name
		end

		def elastic_type_name
			params[:topic_id].to_s
		end

		def scoped_owner(scope)
			has_scope?(scope) ? current_user : current_application
		end

		def has_scope?(scope)
			if doorkeeper_token
				doorkeeper_token.scopes.include?(scope)
			else
				false
			end
		end
	end
end
