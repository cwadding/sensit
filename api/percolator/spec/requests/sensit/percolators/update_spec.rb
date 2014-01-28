require 'spec_helper'
describe "PUT sensit/percolators#update" do

	def url(percolator, format = "json")
		"/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.name}.#{format}"
	end

	def process_oauth_request(access_grant,percolator, params = {}, format = "json")
		oauth_put access_grant, url(percolator, format), valid_request(params.merge!(format: format)), valid_session(:user_id => percolator.topic.user.to_param)
	end

	def process_request(percolator, params = {}, format = "json")
		put url(percolator, format), valid_request(params.merge!(format: format)), valid_session(:user_id => percolator.topic.user.to_param)
	end	

	context "with valid attributes" do
		before(:each) do
			@params = {
				:percolator => {
					:query => { query: { query_string: { query: 'bar' } } }
				}
			}
		end
		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_any_percolations")
				end
				context "writing to own application" do
					before(:each) do
						@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
						@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
					end
					it "returns a 200 status code" do
						response = process_oauth_request(@access_grant,@percolator, @params)
						response.status.should == 200
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@percolator, @params)
						response.body.should be_json_eql("{\"name\": \"#{@percolator.name}\",\"query\": #{@params[:percolator][:query].to_json}}")
					end
				end
				context "updating percolation from another application" do
					before(:each) do
						@application = FactoryGirl.create(:application)
						@topic = FactoryGirl.create(:topic, user: @user, application: @application)
						@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@percolator, @params)
						response.status.should == 200
						response.body.should be_json_eql("{\"name\": \"#{@percolator.name}\",\"query\": #{@params[:percolator][:query].to_json}}")
					end
				end

				context "updating a percolation owned by another user" do
					before(:each) do
						another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
						@percolator = ::Sensit::Topic::Percolator.create({ topic: topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
					end
					it "cannot read data from another user" do
						expect{
							response = process_oauth_request(@access_grant, @percolator, @params)
							response.status.should == 404
						}.to raise_error(ActiveRecord::RecordNotFound)
					end
				end
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "write_application_percolations")
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @percolator, @params)
						response.status.should == 401
					}.to raise_error(OAuth2::Error)
				end
			end
		end
		context "no authentication" do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
			end
			it "is unauthorized" do
				status = process_request(@percolator, @params)
				status.should == 401
			end
		end
	end
end