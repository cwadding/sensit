require 'spec_helper'
describe "GET sensit/reports#show" do

	def process_request(report)
		get "/api/topics/#{report.topic.to_param}/reports/#{report.to_param}", valid_request, valid_session(:user_id => report.topic.user.to_param)
	end


	context "when the report exists" do
		before(:each) do
			@report = FactoryGirl.create(:report, :name => "MyReport-1", :topic => FactoryGirl.create(:topic_with_feeds, user: @user))
		end

		it "is successful" do
			status = process_request(@report)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@report)
			# facet_arr = @report.facets.inject([]) do |facet_arr, facet|
			# 	facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
			# end
			response.body.should be_json_eql("{\"name\":\"#{@report.name}\",\"query\":{\"match_all\":{}},\"total\": 3,\"facets\":[{\"missing\": 0,\"name\": \"#{@report.name}facet\",\"query\": {\"terms\": {\"field\": \"value1\"}},\"results\": [{\"count\": 1,\"term\": 2},{\"count\": 1,\"term\": 1},{\"count\": 1,\"term\": 0}],\"total\": 3}]}")
		end
	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			status = get "/api/topics/1/reports/1", valid_request, valid_session(:user_id => @user.to_param)
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/1/reports/1", valid_request, valid_session(:user_id => @user.to_param)
			}.to raise_error(ActiveRecord::RecordNotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end