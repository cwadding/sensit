require 'spec_helper'
describe "GET sensit/percolators#index" do

	def url(topic,format = "json")
		"/api/topics/#{topic.to_param}/percolators.#{format}"
	end

	def process_oauth_request(access_grant,topic,format = "json")
		oauth_get access_grant, url(topic,format), valid_request, valid_session(user_id:topic.user.to_param)
	end

	def process_request(topic,format = "json")
		get url(topic,format), valid_request, valid_session(user_id:topic.user.to_param)
	end


	context "with > 1 percolator" do
		before(:each) do
			@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_percolations")
			@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
			client = ::Elasticsearch::Client.new
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "10", query: { query: { query_string: { query: 'foo' } } } })
			client.indices.refresh(index: ELASTIC_INDEX_NAME)
		end

		it "is successful" do
			response = process_oauth_request(@access_grant,@topic)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@topic)
			response.body.should be_json_eql("{\"percolators\": [{\"name\":\"#{@percolator.name}\",\"query\":#{@percolator.query.to_json}}]}")
		end
	end

	context "pagination" do
	end

end
