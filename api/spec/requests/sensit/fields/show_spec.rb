require 'spec_helper'
describe "GET sensit/fields#show" do

	def process_request(node)
		topic = @node.topics.first
		field = topic.fields.first
		get "/api/nodes/#{node.id}/topics/#{topic.id}/fields/#{field.id}", valid_request, valid_session
	end

	context "when the field exists" do
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

	context "when the field does not exist" do
		it "is unsuccessful" do
			status = get "/api/nodes/1/topics/1/fields/1", valid_request, valid_session
			status.should == 400
		end

		it "returns the expected json" do
			get "/api/nodes/1/topics/1/fields/1", valid_request, valid_session
			response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end  
end