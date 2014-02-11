require 'spec_helper'
describe "DELETE sensit/publications#destroy" do

	def url(publication, format = "json")
		"/api/topics/#{publication.topic_id}/publications/#{publication.id}"
	end

	def process_oauth_request(access_grant,publication, format = "json")
		oauth_delete access_grant, "/api/topics/#{publication.topic.to_param}/publications/#{publication.id}", valid_request, valid_session(:user_id => publication.topic.user.to_param)
	end

	def process_request(publication, format = "json")
		delete "/api/topics/#{publication.topic.to_param}/publications/#{publication.id}", valid_request, valid_session(:user_id => publication.topic.user.to_param)
	end	


	context "oauth authentication" do
		context "with delete access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_publications")
			end

			context "when the publication exists" do
				before(:each) do
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
					@publication = FactoryGirl.create(:publication, :topic => @topic)
				end

				it "is successful" do
					response = process_oauth_request(@access_grant,@publication)
					response.status.should == 204
				end

				it "deletes the Publication" do
					expect {
						response = process_oauth_request(@access_grant,@publication)
					}.to change(Sensit::Topic::Publication, :count).by(-1)
		        end
			end

			context "when the publication does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_delete @access_grant, "/api/topics/1/publications/1", valid_request, valid_session(:user_id => @user.to_param)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
					#
				end
			end

			context "deleting publication from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@publication = FactoryGirl.create(:publication, :topic => topic)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@publication)
					response.status.should == 204
				end
			end

			context "deleting a publication owned by another user" do
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

		context "with delete access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_publications")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic, user: @user, application: @application)
				@publication = FactoryGirl.create(:publication, :topic => @topic)
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
			@topic = FactoryGirl.create(:topic, user: @user, application: nil)
			@publication = FactoryGirl.create(:publication, :topic => @topic)
		end
		it "is unauthorized" do
			status = process_request(@publication)
			status.should == 401
		end
	end		
end