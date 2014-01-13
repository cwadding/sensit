require 'spec_helper'
describe "GET sensit/percolators#index" do

	def process_request(topic)
		get "/api/topics/#{topic.to_param}/percolators", valid_request, valid_session(topic.user.to_param)
	end


	context "with > 1 percolator" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user)
		end

		it "is successful" do
			percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "10", query: { query: { query_string: { query: 'foo' } } } })
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "11", query: { query: { query_string: { query: 'foo' } } } })
			process_request
			response.body.should be_json_eql("{\"percolators\": [{\"name\":\"#{percolator.id}\",\"query\":#{percolator.query.to_json}}]}")
		end
	end

	context "pagination" do
	end

end
