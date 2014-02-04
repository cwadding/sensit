require 'spec_helper'
describe "PUT sensit/feeds#update" do

	def url(topic, format="json")
		feed = topic.feeds.first
		"/api/topics/#{topic.to_param}/feeds/#{feed.id}.#{format}"
	end


	def process_request(topic, params = {}, format ="json")
		put url(topic,format), valid_request(params.merge!(format: format)), valid_session(:user_id => topic.user.to_param)
	end

	def process_oauth_request(access_grant,topic, params = {}, format ="json")
		oauth_put access_grant, url(topic,format), valid_request(params.merge!(format: format)), valid_session(:user_id => topic.user.to_param)
	end

	context "with valid attributes" do

		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: nil)
			fields = @topic.fields.map(&:key)
			values = {}
			fields.each_with_index do |field, i|
				values.merge!(field => i)
			end
			@params = {
				:feed => {
				   :data => values
				}
			}
		end
		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
					@topic.application = @access_grant.application
					@topic.save
				end

				it "returns a 200 status code" do
					response = process_oauth_request(@access_grant,@topic, @params)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic, @params)
					data_arr = @params[:feed][:data].inject([]) do |arr, (key, value)|
						arr << "\"#{key}\": \"#{value}\""
					end

					field_arr = @topic.fields.inject([]) do |arr, field|
						arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
					end
					response.body.should be_json_eql("{\"at\": \"#{@topic.feeds.first.at.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")}\",\"data\": {#{data_arr.join(',')}},\"fields\": [#{field_arr.join(',')}],\"tz\":\"UTC\"}")
				end

				it "returns the expected xml" do
					pending("xml response")			
					response = process_oauth_request(@access_grant, @topic, @params, "xml")
				end

				context "writing to another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						@params.merge!({:application_id =>  @application.to_param})
						@topic.application = @application
						@topic.save           
					end

					it "is successful" do
						response = process_oauth_request(@access_grant,@topic, @params)
						response.status.should == 200
					end
				end

				context "writing a topic owned by another user" do
					before(:each) do
						@another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						@topic = FactoryGirl.create(:topic_with_feeds, user: @another_user, application: @access_grant.application)
						@topic.save
					end
					it "cannot read data from another user" do
						expect{
							response = process_oauth_request(@access_grant, @topic, @params)
							response.status.should == 404
						}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
					end
				end				
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_data")
					@application = FactoryGirl.create(:application)
					@params.merge!({:application_id =>  @application.to_param})
					@topic.application = @application
					@topic.save
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @topic, @params)
						response.status.should == 404
					}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end			
		end
		context "no authentication" do
			it "is unauthorized" do
				status = process_request(@topic,@params)
				status.should == 401
			end
		end		
	end
end