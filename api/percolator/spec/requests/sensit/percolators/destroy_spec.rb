require 'spec_helper'
describe "DELETE sensit/percolators#destroy" do

	def process_request(percolator)
		delete "/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.id}", valid_request, valid_session(percolator.topic.user.to_param)
	end

	context "when the percolator exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user)
		end

		it "is successful" do
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "3", query: { query: { query_string: { query: 'foo' } } } })
			status = process_request(@percolator)
			status.should == 204
		end

		it "deletes the Percolator" do
			client = ::Elasticsearch::Client.new
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "3", query: { query: { query_string: { query: 'foo' } } } })
			client.indices.refresh(:index => @user.to_param)
			expect {
				process_request(@percolator)
				client.indices.refresh(:index => @user.to_param)
			}.to change(Sensit::Topic::Percolator, :count).by(-1)
        end

 #        it "removes that feed from the elastic_search index"

	end

	context "when the percolator does not exist" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1/percolators/1", valid_request, valid_session
			}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			#status.should == 404
		end
	end	
end