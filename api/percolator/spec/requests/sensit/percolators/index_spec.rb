require 'spec_helper'
describe "GET sensit/percolators#index" do

	def process_request(topic)
		get "/api/topics/#{topic.to_param}/percolators", valid_request, valid_session(user_id:topic.user.to_param)
	end


	context "with > 1 percolator" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user)
			client = ::Elasticsearch::Client.new
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "10", query: { query: { query_string: { query: 'foo' } } } })
			client.indices.refresh(:index => @user.to_param)
		end

		it "is successful" do
			status = process_request(@topic)
			status.should == 200
		end

		it "returns the expected json", :current => true do
			process_request(@topic)
			response.body.should be_json_eql("{\"percolators\": [{\"name\":\"#{@percolator.name}\",\"query\":#{@percolator.query.to_json}}]}")
		end
	end

	context "pagination" do
	end

end
