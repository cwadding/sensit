require 'spec_helper'
describe "GET sensit/publications#show" do

	def url(publication, format = "json")
		"/api/topics/#{publication.topic.to_param}/publications/#{publication.to_param}.#{format}"
	end

	def process_request(publication, format = "json")
		get url(publication, format), valid_request, valid_session(:user_id => publication.topic.user.to_param)
	end

	def process_oauth_request(access_grant,publication, format = "json")
		oauth_get access_grant, url(publication, format), valid_request, valid_session(:user_id => publication.topic.user.to_param)
	end
	context "oauth authentication" do
		context "with read access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_publications")
			end
			context "when the publication exists" do
				before(:each) do
					topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)					
					@publication = FactoryGirl.create(:publication, :topic => topic)
				end

				it "is successful" do
					response = process_oauth_request(@access_grant,@publication)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@publication)
					# facet_arr = @publication.facets.inject([]) do |facet_arr, facet|
					# 	facet_arr << "{\"query\":#{facet.query.to_json}, \"name\":\"#{facet.name}\"}"
					# end
					response.body.should be_json_eql("{\"host\": \"#{@publication.host}\"}")
				end
			end

			context "when the publication does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_get @access_grant, "/api/topics/1/publications/1", valid_request, valid_session(:user_id => @user.to_param)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
					
				end

				it "returns the expected json" do
					expect{
						response = oauth_get @access_grant, "/api/topics/1/publications/1", valid_request, valid_session(:user_id => @user.to_param)
						response.body.should be_json_eql("{\"host\": \"#{@publication.host}\"}")
					}.to raise_error(ActiveRecord::RecordNotFound)
					
				end
			end

			context "reading publication from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
					@publication = FactoryGirl.create(:publication, :topic => topic)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@publication)
					response.status.should == 200
					response.body.should be_json_eql("{\"host\": \"#{@publication.host}\"}")
				end
			end

			context "reading a publication owned by another user" do
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
						response = process_oauth_request(@access_grant, @publication)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end			
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_publications")
				@application = FactoryGirl.create(:application)
				topic = FactoryGirl.create(:topic, user: @user, application: @application)
				@publication = FactoryGirl.create(:publication, :topic => topic)
			end
			it "cannot read data to another application" do
				expect{
					response = process_oauth_request(@access_grant, @publication)
					response.status.should == 404
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end		
	end

	context "no authentication" do
		before(:each) do
			topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: nil)
			@publication = FactoryGirl.create(:publication, :topic => topic)
		end
		it "is unauthorized" do
			status = process_request(@publication)
			status.should == 401
		end
	end	

end