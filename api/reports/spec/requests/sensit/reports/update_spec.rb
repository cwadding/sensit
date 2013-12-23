require 'spec_helper'
describe "PUT sensit/reports#update" do

	before(:each) do
		@report = ::Sensit::Topic::Report.create({ :name => "My Report", :query => { "statistical" => { "field" => "num1"}}, :topic_id => 1})
	end


	def process_request(report, params)
		put "/api/topics/#{report.topic_id}/reports/#{report.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do

		before(:each) do
			@params = {
				:report => {
<<<<<<< HEAD
					:id => "foobar",
					:body => { query: { query_string: { query: 'bar' } } }
=======
					:name => "My New Report",
					:query => { "statistical" => { "field" => "num2"}}
>>>>>>> c1c3b797be8aed6a845d8c345048721b741fa9fb
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
			response.body.should be_json_eql("{\"name\": #{params[:report][:name]},\"query\": #{params[:report][:query].to_json}}")
		end
	end
end