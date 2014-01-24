require 'spec_helper'
describe "POST sensit/percolators#create"  do

	def process_request(topic, params)
		oauth_post "/api/topics/#{topic.to_param}/percolators", valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	context "with correct attributes" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user, application: @application)
		end
		it "returns a 200 status code" do
			@params = {
				:percolator => {
					:name => "foo",
					:query => { query: { query_string: { query: 'foo' } } }
				}
			}
			response =  process_request(@topic, @params)
			response.status.should == 201
		end

		it "returns the expected json" do
			@params = {
				:percolator => {
					:name => "bar",
					:query => { query: { query_string: { query: 'bar' } } }
				}
			}
			response = process_request(@topic, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"name\": \"#{@params[:percolator][:name]}\",\"query\": #{@params[:percolator][:query].to_json}}")
		end
	end

	context "with incorrect attributes" do

	end
end