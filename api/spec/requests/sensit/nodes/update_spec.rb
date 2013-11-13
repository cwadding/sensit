require 'spec_helper'
describe "PUT sensit/nodes#update" do

	before(:each) do
		@node = FactoryGirl.create(:node)
	end


	def process_request(node, params)
		put "/api/nodes/#{node.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:all) do
			@params = {
				:node => {
					:name => "New node name",
					:description => "new description"
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
			response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end

		it "updates a Node" do
			process_request(@node, @params)
			updated_node = Sensit::Node.find(@node.id)
			updated_node.name.should == "New node name"
			updated_node.description.should == "new description"
		end
	end
end