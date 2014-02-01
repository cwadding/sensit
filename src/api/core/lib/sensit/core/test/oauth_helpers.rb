module OAuthHelpers
	def oauth_client(application)
		@oauth_client ||= OAuth2::Client.new(application.uid, application.secret) do |b|
		  b.request :url_encoded
		  b.adapter :rack, Rails.application
		end
	end

	def oauth_access_grant
		@oauth_access_grant ||= Doorkeeper::AccessGrant.first
	end

	def oauth_application
		@oauth_application ||= oauth_access_grant.application
	end

	def oauth_token(access_grant)
		@oauth_token ||= oauth_client(access_grant.application).auth_code.get_token(access_grant.token, redirect_uri: OAUTH2_REDIRECT_URI)
	end


	def oauth_get(access_grant, url, params = {}, session ={})
		oauth_token(access_grant).get( url, params: params)
	end

	def oauth_post(access_grant, url, params = {}, session ={})
		oauth_token(access_grant).post( url, {body: params})
	end

	def oauth_put(access_grant, url, params = {}, session ={})
		oauth_token(access_grant).put( url, body: params)
	end

	def oauth_delete(access_grant, url, params = {}, session ={})
		oauth_token(access_grant).delete( url, body: params)
	end

end