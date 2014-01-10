require 'spec_helper'
describe "GET sensit/topics#index" do

  	def process_request(params = {})
		get "/api/topics/", valid_request(params), valid_session
	end

	context "with no topics" do
		it "returns the expected json" do
			process_request
			response.body.should be_json_eql("{\"topics\":[]}")
		end  
	end

	context "with a single topic" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds, :description => "topic description")
		end
		it "is successful" do
			status = process_request
			status.should == 200
		end

		it "returns the expected json" do
			process_request
			feeds_arr = @topic.feeds.inject([]) do |arr1, feed|
				data_arr = feed.values.inject([]) do |arr2, (key, value)|
					arr2 << "\"#{key}\":#{value}"
				end
				arr1 << "{\"at\":\"#{feed.at.iso8601}\",\"data\":{#{data_arr.join(',')}}}"
			end
			response.body.should be_json_eql("{\"topics\":[{\"id\":#{@topic.id},\"name\":\"#{@topic.name}\",\"description\":\"topic description\",\"feeds\":[#{feeds_arr.join(",")}]}]}")
		end  
	end

	context "with > 1 topic" do
		before(:each) do
			@topics = [FactoryGirl.create(:topic, :name => "T1"), FactoryGirl.create(:topic, :name => "T2"), FactoryGirl.create(:topic, :name => "T3")]
		end
		it "returns the expected json" do
			process_request({page:3, per:1})
			topic = @topics.last
			feeds_arr = topic.feeds.inject([]) do |arr1, feed|
				data_arr = feed.values.inject([]) do |arr2, (key, value)|
					arr2 << "\"#{key}\":#{value}"
				end
				arr1 << "{\"at\":\"#{feed.at.iso8601}\",\"data\":{#{data_arr.join(',')}}}"
			end
			response.body.should be_json_eql("{\"topics\":[{\"id\":#{topic.id},\"name\":\"#{topic.name}\",\"description\": null,\"feeds\":[#{feeds_arr.join(",")}]}]}")
		end  
	end

end