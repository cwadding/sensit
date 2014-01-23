module RequestHelpers
    def valid_request(h = {})
        {:use_route => :sensit_api, :format => "json", :api_version => 1}.merge!(h)
    end

    def valid_session(h={})
      {}.merge!(h)
    end


	def oauth_client
		@oauth_client ||= OAuth2::Client.new(OAUTH2_UID, OAUTH2_SECRET) do |b|
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

	def oauth_token
		@oauth_token ||= oauth_client.auth_code.get_token(OAUTH2_TOKEN, redirect_uri: OAUTH2_REDIRECT_URI)
	end


	def oauth_get(url, params = {}, session ={})
		oauth_token.get( url, params: params)
	end

	def oauth_post(url, params = {}, session ={})
		oauth_token.post( url, {body: params})
	end

	def oauth_put(url, params = {}, session ={})
		oauth_token.put( url, body: params)
	end

	def oauth_delete(url, params = {}, session ={})
		oauth_token.delete( url, body: params)
	end	

end