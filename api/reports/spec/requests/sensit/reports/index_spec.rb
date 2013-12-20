require 'spec_helper'
describe "GET sensit/reports#index" do

	def process_request
		get "/api/topics/1/reports", valid_request, valid_session
	end


	context "with > 1 report" do
		before(:each) do
			@report = ::Sensit::Topic::Report.create({ :name => "My Report", :query => { "statistical" => { "field" => "num1"}}, :topic_id => 1})
		end
		it "is successful" do
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			process_request
			response.body.should be_json_eql("{\"reports\": [{\"name\":\"#{@report.name}\",\"query\":#{@report.query.to_json}}]}")
		end
	end
end
