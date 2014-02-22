require 'spec_helper'

module Sensit
  describe UsersController do

    before(:each) do
      @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_data")
      controller.stub(:doorkeeper_token).and_return(@access_grant)
    end

    def valid_request(h = {})
      h.merge!({:use_route => :sensit_api, :format => "json", :api_version => "1"})
    end
    # This should return the minimal set of attributes required to create a valid
    # Topic. As you add validations to Topic, be sure to
    # update the return value of this method accordingly.
    def valid_attributes
      {}
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # TopicsController. Be sure to keep this updated too.
    def valid_session(params = { })
      {}.merge!(params)
    end

    describe "GET show" do
      it "assigns the requested user as @user" do
        get :show, valid_request, valid_session(user_id: @user.to_param)
        assigns(:user).should eq(@user)
      end
    end
  end
end
