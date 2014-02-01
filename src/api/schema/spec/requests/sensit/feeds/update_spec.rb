require 'spec_helper'
describe "PUT sensit/feeds#update" do

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_data")
		@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
		@feed = @topic.feeds.first
	end


	def process_oauth_request(access_grant,topic, params)
		feed = topic.feeds.first
		oauth_put access_grant, "/api/topics/#{topic.to_param}/feeds/#{feed.id}", valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	context "with correct attributes" do

		it "returns the expected json" do
	         fields = @topic.fields.map(&:key)
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => (i+1).to_s)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }

			response = process_oauth_request(@access_grant,@topic, params)

			field_arr = @topic.fields.inject([]) do |arr, field|
				arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
			end
			# values.merge!(@feed.values)
			data_arr = values.inject([]) do |arr, (key, value)|
				arr << "\"#{key}\": \"#{value}\""
			end
			response.body.should be_json_eql("{\"at\": \"#{@topic.feeds.first.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\": {#{data_arr.join(',')}},\"fields\": [#{field_arr.join(',')}],\"tz\":\"UTC\"}")
		end

		it "returns a 200 status code" do
			 fields = @topic.fields.map(&:key)
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => i)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }
			response = process_oauth_request(@access_grant,@topic, params)
			response.status.should == 200
		end


		it "updates a Feed" do

	         fields = @topic.fields.map(&:key)
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => (i+1).to_s)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }

			response = process_oauth_request(@access_grant,@topic, params)
			# updated_field = Sensit::Topic::Feed.find(:index => @feed.index, :index => @feed.type, :id => @feed.id)
			# updated_field.at.utc.to_f.should == params[:feed][:at]
		end
	end		
end