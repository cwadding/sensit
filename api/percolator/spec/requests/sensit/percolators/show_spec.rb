require 'spec_helper'
describe "GET sensit/percolators#show" do

	def process_request(percolator)
		oauth_get "/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.name}", valid_request, valid_session(user_id: percolator.topic.user.to_param)
	end

	before(:each) do
		@topic = FactoryGirl.create(:topic, user: @user, application: @application)
	end
	context "when the percolator exists" do
		it "is successful" do
			percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "foo", query: { query: { query_string: { query: 'foo' } } } })
			response = process_request(percolator)
			response.status.should == 200
		end

		it "returns the expected json" do
			percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "bar", query: { query: { query_string: { query: 'bar' } } } })
			response = process_request(percolator)
			response.body.should be_json_eql("{\"name\":\"#{percolator.name}\",\"query\":#{percolator.query.to_json}}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
				response = oauth_get "/api/topics/1/percolators/1", valid_request, valid_session
				response.status.should == 404
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			
		end

		it "returns the expected json" do
			expect{
				response = oauth_get "/api/topics/1/percolators/1", valid_request, valid_session
				response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#
		end
	end
end