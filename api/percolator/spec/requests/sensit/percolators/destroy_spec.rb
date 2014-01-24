require 'spec_helper'
describe "DELETE sensit/percolators#destroy" do

	def process_request(percolator)
		oauth_delete "/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.name}", valid_request, valid_session( user_id: percolator.topic.user.to_param)
	end

	context "when the percolator exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user, application: @application)
		end

		it "is successful" do
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "3", query: { query: { query_string: { query: 'foo' } } } })
			response = process_request(@percolator)
			response.status.should == 204
		end

		it "deletes the Percolator" do
			client = ::Elasticsearch::Client.new
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "3", query: { query: { query_string: { query: 'foo' } } } })
			client.indices.refresh(:index => @user.to_param)
			expect {
				response = process_request(@percolator)
				client.indices.refresh(:index => @user.to_param)
			}.to change{::Sensit::Topic::Percolator.count({ topic_id: @topic.to_param, user_id: @user.to_param})}.by(-1)
        end

 #        it "removes that feed from the elastic_search index"

	end

	context "when the percolator does not exist" do
		it "is unsuccessful" do
			expect{
				response = delete "/api/topics/1/percolators/1", valid_request, valid_session
				response.status.should == 404
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
		end
	end	
end