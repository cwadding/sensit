require 'spec_helper'
describe "DELETE sensit/topics#destroy" do

	def process_request(node)
		topic = node.topics.first
		delete "/api/nodes/#{node.id}/topics/#{topic.id}", valid_request, valid_session
	end

	context "when the node exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
			@topic = @node.topics.first
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 204
		end

		it "returns the expected json" do
			process_request(@node)
			response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end

		it "deletes the Topic" do
          expect {
            process_request(@node)
          }.to change(Sensit::Node::Topic, :count).by(-1)
        end

        it "deletes its fields" do
			number_of_fields = @topic.fields.count
			number_of_fields.should > 0
          expect {
            process_request(@node)
          }.to change(Sensit::Node::Topic::Field, :count).by(-1*number_of_fields)
        end

        it "deletes its feeds" do
			number_of_feeds = @topic.feeds.count
			number_of_feeds.should > 0
          expect {
            process_request(@node)
          }.to change(Sensit::Node::Topic::Feed, :count).by(-1*number_of_feeds)
        end        
	end

	context "when the node does not exists" do
		it "is unsuccessful" do
			status = delete "/api/nodes/1/topics/1", valid_request, valid_session
			status.should == 400
		end

		it "returns the expected json" do
			delete "/api/nodes/1/topics/1", valid_request, valid_session
			response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end  
end