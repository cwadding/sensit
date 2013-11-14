require 'spec_helper'
describe "PUT sensit/fields#update" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
		@field = @topic.fields.first
	end


	def process_request(node, params)
		topic = node.topics.first
		field = topic.fields.first
		put "/api/nodes/#{node.id}/topics/#{topic.id}/fields/#{field.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:all) do
			@params = {
				:field => {
					:name => "New field name"
				}
			}
		end
		
		it "returns a 200 status code" do
			status = process_request(@node, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@node, @params)
			expect(response).to render_template(:show)
			topic = @node.topics.first
			field = topic.fields.first
			response.body.should be_json_eql("{\"key\": \"#{field.key}\",\"name\": \"New field name\"}")
		end

		it "updates a Field" do
			process_request(@node, @params)
			updated_field = Sensit::Node::Topic::Field.find(@field.id)
			updated_field.name.should == "New field name"
		end
	end	
end