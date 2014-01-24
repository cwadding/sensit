require 'spec_helper'
describe "DELETE sensit/subscriptions#destroy" do

	def process_request(subscription)
		oauth_delete "/api/topics/#{subscription.topic.to_param}/subscriptions/#{subscription.to_param}", valid_request, valid_session(user_id: subscription.topic.user.to_param)
	end

	context "when the subscription exists" do
		before(:each) do
			topic = FactoryGirl.create(:topic, :user => @user, application: @application)
			@subscription = FactoryGirl.create(:subscription, :topic => topic)
		end
		it "is successful" do
			response = process_request(@subscription)
			response.status.should == 204
		end

		it "deletes the Subscription" do
			expect {
				response = process_request(@subscription)
			}.to change(Sensit::Topic::Subscription, :count).by(-1)
        end

 #        it "removes that feed from the elastic_search index"

	end

	context "when the subscription does not exist" do
		it "is unsuccessful" do
			expect{
				response = oauth_delete "/api/topics/1/subscriptions/1", valid_request, valid_session(user_id: @user.to_param)
				response.status.should == 404
			}.to raise_error(ActiveRecord::RecordNotFound)
		end
	end	
end