require 'spec_helper'
describe "PUT sensit/reports#update" do

	before(:each) do
		@report = ::Sensit::Topic::Report.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } })
	end


	def process_request(report, params)
		put "/api/topics/#{report.type}/reports/#{report.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do

		before(:each) do
			@params = {
				:report => {
					:id => "foobar"
					:body => { query: { query_string: { query: 'bar' } } }
				}
			}
		end
		it "returns a 200 status code" do
			status = process_request(@report, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@report, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"id\": #{params[:report][:id]},\"body\": #{params[:report][:body].to_json}}")
		end
	end
end