require 'spec_helper'
describe "POST sensit/subscriptions#create"  do

	def process_request(topic, params)
		post "/api/topics/#{topic.to_param}/subscriptions", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:each) do
			@topic = FactoryGirl.create(:topic)
			@params = {
				:subscription => {
					:name => "MyString",
					:host => "127.0.0.1"
				}
			}
		end
		it "returns a 200 status code" do
			status = process_request(@topic, @params)
			status.should == 201
		end

		it "returns the expected json" do
			process_request(@topic, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"name\": \"#{@params[:subscription][:name]}\",\"host\": \"#{@params[:subscription][:host]}\"}")
		end
	end

	context "with incorrect attributes" do

	end
end