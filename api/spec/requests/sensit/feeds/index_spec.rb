require 'spec_helper'
describe "GET sensit/feeds#index" do

	def process_request(node)
		topic = @node.topics.first
		get "/api/nodes/#{node.id}/topics/#{topic.id}/feeds", valid_request, valid_session
	end

	context "when the feed exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@node)
			response.body.should be_json_eql('{"feeds": [{"at": "2013-11-14T03:56:05.000Z","data": [{"key24": "Value24"}],"fields": [{"key": "key19","name": "Field19"}]},{"at": "2013-11-14T03:56:05.000Z","data": [{"key25": "Value25"}],"fields": [{"key": "key20","name": "Field20"}]},{"at": "2013-11-14T03:56:05.000Z","data": [{"key26": "Value26"}],"fields": [{"key": "key21","name": "Field21"}]}]')
		end
	end
end
