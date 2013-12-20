require 'spec_helper'
describe "GET sensit/topics#index" do

  	def process_request
		get "/api/topics/", valid_request, valid_session
	end

	context "when the topic exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, :description => "topic description")
		end
		it "is successful" do
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			process_request
			fields_arr = @topic.fields.inject([]) do |arr, field|
				arr << "{\"name\":\"#{field.name}\",\"key\":\"#{field.key}\"}"
			end
			feeds_arr = @topic.feeds.inject([]) do |arr1, feed|
				data_arr = feed.values.inject([]) do |arr2, (key, value)|
					arr2 << "\"#{key}\":#{value}"
				end
				arr1 << "{\"at\":#{feed.at.to_f},\"data\":{#{data_arr.join(',')}}}"
			end
			response.body.should be_json_eql("{\"topics\":[{\"id\":#{@topic.id},\"name\":\"#{@topic.name}\",\"description\":\"topic description\",\"fields\":[#{fields_arr.join(",")}],\"feeds\":[#{feeds_arr.join(",")}]}]}")
		end  
	end
end