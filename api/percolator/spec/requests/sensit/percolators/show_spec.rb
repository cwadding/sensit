require 'spec_helper'
describe "GET sensit/percolators#show" do

	def process_request(percolator)
		get "/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.id}", valid_request, valid_session(percolator.topic.user.to_param)
	end

	before(:each) do
		@topic = FactoryGirl.create(:topic, user: @user)
	end
	context "when the percolator exists" do
		it "is successful" do
			percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "foo", query: { query: { query_string: { query: 'foo' } } } })
			status = process_request(percolator)
			status.should == 200
		end

		it "returns the expected json" do
			percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "bar", query: { query: { query_string: { query: 'bar' } } } })
			process_request(percolator)
			response.body.should be_json_eql("{\"name\":\"#{percolator.id}\",\"query\":#{percolator.query.to_json}}")
		end

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
			status = get "/api/topics/1/percolators/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/1/percolators/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end
end