require 'spec_helper'
describe "POST sensit/reports#create"  do

	def process_request(topic, params)
		post "/api/topics/#{topic.to_param}/reports", valid_request(params), valid_session
	end
	context "with facets" do 
		context "with correct attributes" do
			before(:each) do
				@topic = FactoryGirl.create(:topic)
				@params = {
					:report => {
						:name => "My Report"
					}
				}
				# :facets => { "statistical" => { "field" => "num1"}}
			end
			it "returns a 200 status code" do
				status = process_request(@topic, @params)
				status.should == 201
			end

			it "returns the expected json" do
				process_request(@topic, @params)
				expect(response).to render_template(:show)
				response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"facets\":[]}")
			end
		end
		context "with incorrect attributes" do

		end
	end
	context "without facets" do
		#{@params[:report][:facets].to_json		
	end


end