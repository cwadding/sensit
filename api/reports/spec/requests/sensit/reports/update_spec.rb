require 'spec_helper'
describe "PUT sensit/reports#update" do

	before(:each) do
		@report = FactoryGirl.create(:report, :name => "My Report")
	end


	def process_request(report, params)
		put "/api/topics/#{report.topic.to_param}/reports/#{report.id}", valid_request(params), valid_session
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
				facet_arr << "{\"body\":#{facet.body.to_json}, \"name\":\"#{facet.name}\"}"
			end
			response.body.should be_json_eql("{\"name\": \"#{@params[:report][:name]}\",\"query\":{\"match_all\":{}},\"facets\": [#{facet_arr.join(',')}]}")
		end
	end
	# #{@params[:report][:facets].to_json}
end