require 'spec_helper'
describe "PUT sensit/publications#update" do

	def url(publication, format= "json")
		"/api/topics/#{publication.topic.to_param}/publications/#{publication.to_param}"
	end

	def process_oauth_request(access_grant,publication, params, format= "json")
		oauth_put access_grant, url(publication, format), valid_request(params), valid_session(:user_id => publication.topic.user.to_param)
	end

	def process_request(publication, params, format= "json")
		put url(publication, format), valid_request(params), valid_session(:user_id => publication.topic.user.to_param)
	end

	context "with valid attributes" do

		before(:each) do
			@params = {
				:publication => {
					:host => "127.0.0.1",
					:protocol => "mqtt"
				}
			}
		end

		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_publications")
				end
				context "a publication from the application and user" do
					before(:each) do
						@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
						@publication = FactoryGirl.create(:publication, :topic => @topic)
					end
					it "returns a 200 status code" do
						response = process_oauth_request(@access_grant,@publication, @params)
						response.status.should == 200
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@publication, @params)
						response.body.should be_json_eql("{\"host\": \"#{@params[:publication][:host]}\", \"protocol\": \"#{@params[:publication][:protocol]}\"}")
					end
				end

				context "updating publication from another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
						@publication = FactoryGirl.create(:publication, :topic => topic)
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@publication, @params)
						response.status.should == 200
						response.body.should be_json_eql("{\"host\": \"#{@params[:publication][:host]}\", \"protocol\": \"#{@params[:publication][:protocol]}\"}")
					end
				end

				context "updating a publication owned by another user" do
					before(:each) do
						@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
						another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
						@publication = FactoryGirl.create(:publication, :topic => topic)
					end
					after(:each) do
						@client.indices.flush(index: "another_user", refresh: true)
					end						
					it "cannot read data from another user" do
						expect{
							response = process_oauth_request(@access_grant, @publication, @params)
							response.status.should == 404
						}.to raise_error(ActiveRecord::RecordNotFound)
					end
				end
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_publications")
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@publication = FactoryGirl.create(:publication, :topic => @topic)
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @publication, @params)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end				
		end
		context "no authentication" do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@publication = FactoryGirl.create(:publication, :topic => @topic)
			end
			it "is unauthorized" do
				status = process_request(@publication, @params)
				status.should == 401
			end
		end		
	end
end