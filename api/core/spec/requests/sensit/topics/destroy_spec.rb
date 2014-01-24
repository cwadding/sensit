require 'spec_helper'
describe "DELETE sensit/topics#destroy" do

	def process_request(topic)
		oauth_delete "/api/topics/#{topic.to_param}", valid_request, valid_session
	end

	context "when the node exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
		end
		it "is successful" do
			response = process_request(@topic)
			response.status.should == 204
		end

		it "deletes the Topic" do
          expect {
            response = process_request(@topic)
          }.to change(Sensit::Topic, :count).by(-1)
        end

        it "deletes its feeds" do
        	client = ::Elasticsearch::Client.new
			number_of_feeds = @topic.feeds.count
			number_of_feeds.should > 0
			expect {
				response = process_request(@topic)
				client.indices.refresh(:index => @user.to_param)
			}.to change(Sensit::Topic::Feed, :count).by(-1*number_of_feeds)
        end
	end

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				response = oauth_delete "/api/topics/1", valid_request, valid_session
				response.status.should == 404
			}.to raise_error(ActiveRecord::RecordNotFound)
			
		end
	end  
end