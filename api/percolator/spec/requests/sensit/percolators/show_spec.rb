require 'spec_helper'
describe "GET sensit/percolators#show" do

	def process_oauth_request(access_grant,percolator)
		oauth_get access_grant, "/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.name}", valid_request, valid_session(user_id: percolator.topic.user.to_param)
	end

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_percolations")
		@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
	end
	context "when the percolator exists" do
		before(:each) do
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "foo", query: { query: { query_string: { query: 'foo' } } } }) 
		end
		it "is successful" do
			response = process_oauth_request(@access_grant, @percolator)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant, @percolator)
			response.body.should be_json_eql("{\"name\":\"#{@percolator.name}\",\"query\":#{@percolator.query.to_json}}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
				response = oauth_get @access_grant, "/api/topics/1/percolators/1", valid_request, valid_session
				response.status.should == 404
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			
		end

		it "returns the expected json" do
			expect{
				response = oauth_get @access_grant, "/api/topics/1/percolators/1", valid_request, valid_session
				response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#
		end
	end
end