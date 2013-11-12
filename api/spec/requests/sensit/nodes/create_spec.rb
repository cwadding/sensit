require 'spec_helper'
describe "POST sensit/nodes#create" do

	def process_request(params)
		post "/api/nodes", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:all) do
			@params = {
				:node => {
					:name => "Test node",
					:description => "A description of my node"
				}
			}
		end
		
		it "returns a 200 status code" do
			status = process_request(@params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end

		it "creates a new Node" do
          expect {
            process_request(@params)
          }.to change(Sensit::Node, :count).by(1)
        end
	end

	context "without the name attribute" do
		before(:all) do
			@params = {
				:node => {
					:description => "A description of my node"
				}
			}
		end

		it "is an unprocessable entity" do
			status = process_request(@params)
			status.should == 422
		end

		it "returns the expected json" do
			process_request(@params)
			response.body.should be_json_eql("{\"errors\":{\"name\":[\"can't be blank\"]}}")
		end
	end

	context "without a unique name attribute" do
		before(:each) do
			FactoryGirl.create(:node, :name => "Existing Node")
		end
		before(:all) do
			@params = {
				:node => {
					:name => "Existing Node"
				}
			}
		end
		it "is an unprocessable entity" do
			status = process_request(@params)
			status.should == 422
		end

		it "returns the expected json" do
			process_request(@params)
			response.body.should be_json_eql("{\"errors\":{\"name\":[\"has already been taken\"]}}")
		end
	end
end