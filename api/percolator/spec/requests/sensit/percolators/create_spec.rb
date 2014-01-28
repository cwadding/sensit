require 'spec_helper'
describe "POST sensit/percolators#create"  do

	def url(topic, format = "json")
		"/api/topics/#{topic.to_param}/percolators.#{format}"
	end

	def process_oauth_request(access_grant,topic, params)
		oauth_post access_grant, url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic, params)
		post url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end	

	context "with valid attributes" do
		before(:each) do
			@params = {
				:percolator => {
					:name => "foo",
					:query => { query: { query_string: { query: 'foo' } } }
				}
			}
		end
		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_percolations")
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
				end
				context "creating percolations on the current application and user" do
					it "returns a 200 status code" do
						response =  process_oauth_request(@access_grant,@topic, @params)
						response.status.should == 201
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@topic, @params)
						response.body.should be_json_eql("{\"name\": \"#{@params[:percolator][:name]}\",\"query\": #{@params[:percolator][:query].to_json}}")
					end
				end

				context "creating percolation for another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						@topic = FactoryGirl.create(:topic, user: @user, application: @application)
						@params.merge!({:application_id =>  @application.to_param})
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@topic, @params)
						response.status.should == 200
						response.body.should be_json_eql("{\"name\": \"#{@params[:percolator][:name]}\",\"query\": #{@params[:percolator][:query].to_json}}")
					end
				end

				context "creating a percolation owned by another user" do
					before(:each) do
						another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						@topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					end
					it "cannot read data from another user" do
						expect{
							response = process_oauth_request(@access_grant, @topic, @params)
							response.status.should == 401
						}.to raise_error(OAuth2::Error)
					end
				end
			end

			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_application_percolations")
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@params.merge!({:application_id =>  @application.to_param})
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @topic, @params)
						response.status.should == 401
					}.to raise_error(OAuth2::Error)
				end
			end			
		end

		context "no authentication" do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user, application: nil)
			end
			it "is unauthorized" do
				status = process_request(@topic, @params)
				status.should == 401
			end
		end		
	end

	context "with incorrect attributes" do

	end
end