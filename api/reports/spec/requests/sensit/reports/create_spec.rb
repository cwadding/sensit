require 'spec_helper'
describe "POST sensit/reports#create"  do

	def process_request(topic, params)
		post "/api/topics/#{topic.to_param}/reports", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:each) do
			@topic = FactoryGirl.create(:topic)
			@params = {
				:report => {
					:name => "My Report",
					:query => { "statistical" => { "field" => "num1"}}
				}
			}
		end
		it "returns a 200 status code" do
			status = process_request(@topic, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@topic, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\": #{@params[:report][:query].to_json}}")
		end
	end

	context "with incorrect attributes" do

	end
end