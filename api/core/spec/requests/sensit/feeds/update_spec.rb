require 'spec_helper'
describe "PUT sensit/feeds#update" do




	def process_oauth_request(access_grant,topic, params = {}, format ="json")
		feed = topic.feeds.first
		oauth_put access_grant, "/api/topics/#{topic.to_param}/feeds/#{feed.id}.#{format}", valid_request(params.merge!(format: format)), valid_session(:user_id => topic.user.to_param)
	end


	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_data")
		@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
		@feed = @topic.feeds.first
	end

	context "with correct attributes" do

		before(:each) do
		fields = @topic.feeds.first.values.keys
		values = {}
		fields.each_with_index do |field, i|
			values.merge!(field => i)
		end
		@params = {
			:feed => {
			   :values => values
			}
		}
		end

		it "returns a 200 status code" do
			response = process_oauth_request(@access_grant,@topic, @params)
			response.status.should == 200
		end

		it "returns the expected json" do
			response = process_oauth_request(@access_grant,@topic, @params)
			data_arr = @params[:feed][:values].inject([]) do |arr, (key, value)|
				arr << "\"#{key}\": \"#{value}\""
			end
			response.body.should be_json_eql("{\"at\": \"#{@topic.feeds.first.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\": {#{data_arr.join(',')}},\"tz\":\"UTC\"}")
		end

		it "returns the expected xml" do
			pending("xml response")			
			response = process_oauth_request(@access_grant, @topic, @params, "xml")
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

			response = process_oauth_request(@access_grant,@topic, params)
			# updated_field = Sensit::Topic::Feed.find(:index => @feed.index, :index => @feed.type, :id => @feed.id)
			# updated_field.at.utc.to_f.should == params[:feed][:at]
		end
	end		
end