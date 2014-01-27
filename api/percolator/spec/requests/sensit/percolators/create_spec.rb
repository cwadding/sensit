require 'spec_helper'
describe "POST sensit/percolators#create"  do

	def url(topic, format = "json")
		"/api/topics/#{topic.to_param}/percolators.#{format}"
	end

	def process_oauth_request(access_grant,topic, params)
		oauth_post access_grant, url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic, params)
		post url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end	

	context "with correct attributes" do
		before(:each) do
			@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_percolations")
			@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
		end
		it "returns a 200 status code" do
			@params = {
				:percolator => {
					:name => "foo",
					:query => { query: { query_string: { query: 'foo' } } }
				}
			}
			response =  process_oauth_request(@access_grant,@topic, @params)
			response.status.should == 201
		end

		it "returns the expected json" do
			@params = {
				:percolator => {
					:name => "bar",
					:query => { query: { query_string: { query: 'bar' } } }
				}
			}
			response = process_oauth_request(@access_grant,@topic, @params)
			response.body.should be_json_eql("{\"name\": \"#{@params[:percolator][:name]}\",\"query\": #{@params[:percolator][:query].to_json}}")
		end
	end

	context "with incorrect attributes" do

	end
end