require 'spec_helper'
describe "PUT sensit/percolators#update" do

	def process_oauth_request(access_grant,percolator, params)
		oauth_put access_grant, "/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.name}", valid_request(params), valid_session(:user_id => percolator.topic.user.to_param)
	end

	context "with correct attributes" do
		before(:each) do
			@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_percolations")
			@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
		end
		it "returns a 200 status code" do
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "4",  query: { query: { query_string: { query: 'foo' } } } })
			@params = {
				:percolator => {
					:name => "5",
					:query => { query: { query_string: { query: 'bar' } } }
				}
			}
			response = process_oauth_request(@access_grant,@percolator, @params)
			response.status.should == 200
		end

		it "returns the expected json" do
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "3", query: { query: { query_string: { query: 'foo' } } } })
			@params = {
				:percolator => {
					:query => { query: { query_string: { query: 'bar' } } }
				}
			}

			response = process_oauth_request(@access_grant,@percolator, @params)
			response.body.should be_json_eql("{\"name\": \"#{@percolator.name}\",\"query\": #{@params[:percolator][:query].to_json}}")
		end
	end
end