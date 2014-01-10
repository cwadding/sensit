require 'spec_helper'
describe "PUT sensit/feeds#update" do

	before(:each) do
		@topic = FactoryGirl.create(:topic_with_feeds)
		@feed = @topic.feeds.first
	end


	def process_request(topic, params)
		feed = topic.feeds.first
		put "/api/topics/#{topic.to_param}/feeds/#{feed.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do

		it "returns the expected json" do
	         fields = @topic.feeds.first.values.keys
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => (i+1).to_s)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }

			process_request(@topic, params)
			expect(response).to render_template(:show)
			# values.merge!(@feed.values)
			data_arr = values.inject([]) do |arr, (key, value)|
				arr << "\"#{key}\": \"#{value}\""
			end
			response.body.should be_json_eql("{\"at\": \"#{@topic.feeds.first.at.utc.iso8601}\",\"data\": {#{data_arr.join(',')}},\"tz\":\"UTC\"}")
		end

		it "returns a 200 status code" do
			 fields = @topic.feeds.first.values.keys
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => i)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }
			status = process_request(@topic, params)
			status.should == 200
		end


		it "updates a Feed" do

	         fields = @topic.feeds.first.values.keys
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => (i+1).to_s)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }

			process_request(@topic, params)
			# updated_field = Sensit::Topic::Feed.find(:index => @feed.index, :index => @feed.type, :id => @feed.id)
			# updated_field.at.utc.to_f.should == params[:feed][:at]
		end
	end		
end