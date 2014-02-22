module Sensit
	class ApiController < ActionController::Base

		# force_ssl if: :ssl_configured?
		# protect_from_forgery :null_session
		# def ssl_configured?
		# 	true # Rails.env.production?
		# end

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

		def attempting_to_write_to_another_application_without_privilage(root_key)
			!has_scope?("manage_any_data") && application_id_from_params(root_key).has_key?(:application_id) && application_id_from_params(root_key)[:application_id].to_s != doorkeeper_token.application_id.to_s
		end

		def application_id_from_params(root_key)
			@application_id_from_params ||= params.require(root_key).permit(:application_id)
		end

		def attempting_to_access_topic_from_another_application_without_privilage(scope)
			(!has_scope?(scope) && (!current_application.topics.map(&:slug).include?(params[:topic_id].to_s)) || !current_user.topics.map(&:slug).include?(params[:topic_id].to_s))
		end

		def elastic_index_name
			current_user.name.parameterize
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
