require 'spec_helper'
describe "DELETE sensit/reports#destroy" do

	def process_request(report)
		delete "/api/topics/#{report.topic_id}/reports/#{report.id}", valid_request, valid_session
	end

	context "when the report exists" do
		before(:each) do
          @report = ::Sensit::Topic::Report.create({ :name => "My Report", :query => { "statistical" => { "field" => "num1"}}, :topic_id => 1})
		end
		it "is successful" do
			status = process_request(@report)
			status.should == 204
		end

		it "deletes the Report" do
			expect {
				process_request(@report)
			}.to change(Sensit::Topic::Report, :count).by(-1)
        end

 #        it "removes that feed from the elastic_search index"

	end

	context "when the report does not exist" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1/reports/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end
	end	
end