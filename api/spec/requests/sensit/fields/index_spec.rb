require 'spec_helper'
describe "GET sensit/fields#index" do

	def process_request(topic)
		get "/api/topics/#{topic.id}/fields", valid_request, valid_session
	end


	context "when the feed exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields)
		end
		it "is successful" do
			status = process_request(@topic)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@topic)
			fields_arr = @topic.fields.inject([]) do |arr, field|
				arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
			end
			response.body.should be_json_eql("{\"fields\": [#{fields_arr.join(',')}]}")
		end
	end
end
