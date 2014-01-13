module Sensit
	class ApiController < ActionController::Base
		# http_basic_authenticate_with name: "admin", password: "secret"
		# before_filter :restrict_access

      def elastic_index_name
        session[:user_id]
      end
      def elastic_type_name
        params[:topic_id].to_s
      end

		# def restrict_access
		#   api_key = ApiKey.find_by_access_token(params[:access_token])
		#   head :unauthorized unless api_key
		# end

		def restrict_access
			authenticate_or_request_with_http_token do |token, options|
				ApiKey.exists?(access_token: token)
			end
		end

		def current_user
			@current_user ||= User.find(session[:user_id]) if session[:user_id]
		end
		helper_method :current_user

		def authorize
			redirect_to login_url, alert: "Not authorized" if current_user.nil?
		end
	end
end
