require 'spec_helper'
describe "GET sensit/percolators#index" do

	def process_request(topic)
		oauth_get "/api/topics/#{topic.to_param}/percolators", valid_request, valid_session(user_id:topic.user.to_param)
	end


	context "with > 1 percolator" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user, application: @application)
			client = ::Elasticsearch::Client.new
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "10", query: { query: { query_string: { query: 'foo' } } } })
			client.indices.refresh(:index => @user.to_param)
		end

		it "is successful" do
			response = process_request(@topic)
			response.status.should == 200
		end

		it "returns the expected json", :current => true do
			response = process_request(@topic)
			response.body.should be_json_eql("{\"percolators\": [{\"name\":\"#{@percolator.name}\",\"query\":#{@percolator.query.to_json}}]}")
		end
	end

	context "pagination" do
	end

end
