require 'spec_helper'
describe "GET sensit/fields#index" do

	def process_request(node)
		topic = @node.topics.first
		get "/api/nodes/#{node.id}/topics/#{topic.id}/fields", valid_request, valid_session
	end


	context "when the feed exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@node)
			response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end