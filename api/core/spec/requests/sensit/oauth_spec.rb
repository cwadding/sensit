require 'spec_helper'
describe "GET doorkeeper/authorize#new" do

	it "auth ok" do
		oauth_token.should_not be_expired
	end

	it "invalid token" do
		expect {
			oauth_client.auth_code.get_token("someothertoken", redirect_uri: OAUTH2_REDIRECT_URI)
		}.to raise_error(OAuth2::Error)
	end
end