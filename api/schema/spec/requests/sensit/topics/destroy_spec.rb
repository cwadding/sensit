require 'spec_helper'
describe "DELETE sensit/topics#destroy" do

	def process_request(topic)
		delete "/api/topics/#{topic.to_param}", valid_request, valid_session(:user_id => topic.user.to_param)
	end

	context "when the node exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user)
		end
		it "is successful" do
			status = process_request(@topic)
			status.should == 204
		end

		it "deletes the Topic" do
          expect {
            process_request(@topic)
          }.to change(Sensit::Topic, :count).by(-1)
        end

        it "deletes its fields" do
			number_of_fields = @topic.fields.count
			number_of_fields.should > 0
          expect {
            process_request(@topic)
          }.to change(Sensit::Topic::Field, :count).by(-1*number_of_fields)
        end

        it "deletes its feeds" do
        	client = ::Elasticsearch::Client.new
			number_of_feeds = @topic.feeds.count
			number_of_feeds.should > 0
			expect {
				process_request(@topic)
				client.indices.refresh(:index => @user.to_param)
			}.to change(Sensit::Topic::Feed, :count).by(-1*number_of_feeds)
        end
	end

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1", valid_request, valid_session(user_id:@user.to_param)
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end
	end  
end