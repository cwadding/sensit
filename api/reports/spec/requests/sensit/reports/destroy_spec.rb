require 'spec_helper'
describe "DELETE sensit/reports#destroy" do

	def process_request(report)
		delete "/api/topics/#{report.type}/reports/#{report.id}", valid_request, valid_session
	end

	context "when the report exists" do
		before(:each) do
          @report = ::Sensit::Topic::Report.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
		end
		it "is successful" do
			status = process_request(@report)
			status.should == 204
		end

		it "deletes the Report" do
			client = ::Elasticsearch::Client.new
			expect {
				process_request(@report)
				client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
			}.to change(Sensit::Topic::Report, :count).by(-1)
        end

 #        it "removes that feed from the elastic_search index"

	end

	context "when the report does not exist" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1/reports/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end
	end	
end