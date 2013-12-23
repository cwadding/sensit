require 'spec_helper'
describe "GET sensit/reports#show" do

	def process_request(report)
		get "/api/topics/#{report.topic.to_param}/reports/#{report.id}", valid_request, valid_session
	end


	context "when the report exists" do
		before(:each) do
			@report = FactoryGirl.create(:report)
		end

		it "is successful" do
			status = process_request(@report)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@report)
			response.body.should be_json_eql("{\"name\":\"#{@report.name}\",\"query\":#{@report.query.to_json}}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			status = get "/api/topics/1/reports/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/1/reports/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end