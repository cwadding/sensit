require 'spec_helper'
describe "PUT sensit/reports#update" do

	before(:each) do
		@report = FactoryGirl.create(:report, :name => "My Report", :topic => FactoryGirl.create(:topic_with_feeds))
	end


	def process_request(report, params)
		put "/api/topics/#{report.topic.to_param}/reports/#{report.to_param}", valid_request(params), valid_session
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
			status = process_request(@report, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@report, @params)
			expect(response).to render_template(:show)
			facet_arr = @report.facets.inject([]) do |facet_arr, facet|
				facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
			end
			response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"total\": 3,\"facets\": [{\"missing\": 0,\"name\": \"My Reportfacet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}]}")
		end

	end
	# #{@params[:report][:facets].to_json}
end