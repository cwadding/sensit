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
			topic = @node.topics.first
			feed = topic.feeds.first
			field_arr = topic.fields.inject([]) do |arr, field|
				arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
			end
			data_arr = feed.data_rows.inject([]) do |arr, datum|
				arr << "{\"#{datum.key}\": \"#{datum.value}\"}"
			end
			response.body.should be_json_eql("{\"feeds\": [{\"at\": \"#{feed.at.strftime("%Y-%m-%dT%H:%M:%S.000Z")}\",\"data\": [#{data_arr.join(',')}],\"fields\": [#{field_arr.join(',')}]}]}")
		end
	end
end
