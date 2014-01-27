require 'spec_helper'
describe "DELETE sensit/percolators#destroy" do


	def url(percolator, format ="json")
		"/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.name}"
	end

	def process_oauth_request(access_grant,percolator, format ="json")
		oauth_delete access_grant, url(percolator, format), valid_request(format: format), valid_session( user_id: percolator.topic.user.to_param)
	end

	def process_equest(percolator, format ="json")
		delete url(percolator, format), valid_request(format: format), valid_session( user_id: percolator.topic.user.to_param)
	end

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_any_percolations")
	end
	context "when the percolator exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
		end

		it "is successful" do
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "3", query: { query: { query_string: { query: 'foo' } } } })
			response = process_oauth_request(@access_grant,@percolator)
			response.status.should == 204
		end

		it "deletes the Percolator" do
			client = ::Elasticsearch::Client.new
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "3", query: { query: { query_string: { query: 'foo' } } } })
			client.indices.refresh(index: ELASTIC_INDEX_NAME)
			expect {
				response = process_oauth_request(@access_grant,@percolator)
				client.indices.refresh(index: ELASTIC_INDEX_NAME)
			}.to change{::Sensit::Topic::Percolator.count({ topic_id: @topic.to_param, user_id: @user.name})}.by(-1)
        end

 #        it "removes that feed from the elastic_search index"

	end

	context "when the percolator does not exist" do
		it "is unsuccessful" do
			expect{
				response = oauth_delete @access_grant, "/api/topics/1/percolators/1", valid_request, valid_session
				response.status.should == 404
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
		end
	end	
end