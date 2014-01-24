require 'spec_helper'
describe "POST sensit/reports#create"  do

	def process_request(topic, params)
		oauth_post "/api/topics/#{topic.to_param}/reports", valid_request(params), valid_session(:user_id => topic.user.to_param)
	end
	context "with facets" do 
		context "with correct attributes" do
			before(:each) do
				@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
				@params = {
					:report => {
						:name => "My Report",
						:facets => [{"name" => "facet1", "query" => { :terms => { :field => "value1"}}}]
					}
				}
				# 
			end
			it "returns a 200 status code" do
				response = process_request(@topic, @params)
				response.status.should == 201
			end

			it "returns the expected json" do
				response = process_request(@topic, @params)
				expect(response).to render_template(:show)
				response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"facets\":[{\"missing\": 0,\"name\": \"facet1\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}], \"total\":3}")
			end
		end
		context "with incorrect attributes" do

		end
	end
	context "without facets" do
		#{@params[:report][:facets].to_json		
	end

end