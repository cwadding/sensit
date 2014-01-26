require 'spec_helper'
describe "GET doorkeeper/authorize#new" do
	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id)
	end
	it "auth ok" do
		oauth_token(@access_grant).should_not be_expired
	end

	it "invalid token" do
		expect {
			oauth_client(@access_grant.application).auth_code.get_token("someothertoken", redirect_uri: OAUTH2_REDIRECT_URI)
		}.to raise_error(OAuth2::Error)
	end
end