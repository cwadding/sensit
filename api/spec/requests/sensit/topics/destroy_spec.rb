require 'spec_helper'
describe "DELETE sensit/topics#destroy" do

	def process_request(topic)
		delete "/api/topics/#{topic.id}", valid_request, valid_session
	end

	context "when the node exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields)
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

        it "deletes its feeds", :current => true do
        	client = ::Elasticsearch::Client.new
			number_of_feeds = @topic.feeds.count
			number_of_feeds.should > 0
			expect {
				process_request(@topic)
				client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
			}.to change(Sensit::Topic::Feed, :count).by(-1*number_of_feeds)
        end
	end

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end
	end  
end