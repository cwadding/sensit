require 'spec_helper'
describe "PUT sensit/reports#update" do

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_reports")
		@report = FactoryGirl.create(:report, :name => "My Report", :topic => FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application))
	end


	def process_oauth_request(access_grant,report, params)
		oauth_put access_grant, "/api/topics/#{report.topic.to_param}/reports/#{report.to_param}", valid_request(params), valid_session(:user_id => report.topic.user.to_param)
	end

	context "with correct attributes" do

		before(:each) do
			@params = {
				:report => {
					:name => "My New Report"
				}
			}
			# :facets => { "statistical" => { "field" => "num2"}}
		end
		it "returns a 200 status code" do
			response = process_oauth_request(@access_grant,@report, @params)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@report, @params)
			facet_arr = @report.facets.inject([]) do |facet_arr, facet|
				facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
			end
			response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"total\": 3,\"facets\": [{\"missing\": 0,\"name\": \"My Reportfacet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}]}")
		end

	end
	# #{@params[:report][:facets].to_json}
end