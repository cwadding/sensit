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
					:query => { query_string: { query: 'bar' } }
				}
			}
		end
		context "oauth authentication" do
			context "with write access to the users data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_percolations")
				end
				context "writing to own application" do
					before(:each) do
						@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
						@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query_string: { query: 'foo' } } })
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
						@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query_string: { query: 'foo' } } })
					end

					it "returns the expected json" do
						response = process_oauth_request(@access_grant,@percolator, @params)
						response.status.should == 200
						response.body.should be_json_eql("{\"name\": \"#{@percolator.name}\",\"query\": #{@params[:percolator][:query].to_json}}")
					end
				end

				context "updating a percolation owned by another user" do
					before(:each) do
						@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
						another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
						topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
						@percolator = ::Sensit::Topic::Percolator.create({ topic: topic, :name => "5",  query: { query_string: { query: 'foo' } } })
					end
					after(:each) do
						@client.indices.flush(index: "another_user", refresh: true)
					end
					it "cannot read data from another user" do
						expect{
							response = process_oauth_request(@access_grant, @percolator, @params)
							response.status.should == 404
						}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
					end
				end
			end
			context "with write access to only the applications data" do
				before(:each) do
					@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_percolations")
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query_string: { query: 'foo' } } })
				end
				it "cannot update data to another application" do
					expect{
						response = process_oauth_request(@access_grant, @percolator, @params)
						response.status.should == 404
					}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end
		end
		context "no authentication" do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query_string: { query: 'foo' } } })
			end
			it "is unauthorized" do
				status = process_request(@percolator, @params)
				status.should == 401
			end
		end
	end
end