require 'spec_helper'
describe "DELETE sensit/fields#destroy" do

	def url(topic, format="json")
		field = topic.fields.first
		"/api/topics/#{topic.to_param}/fields/#{field.to_param}.#{format}"
	end

	def process_oauth_request(access_grant,topic,format="json")
		oauth_delete access_grant, url(topic, format), valid_request, valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic,format="json")
		delete url(topic, format), valid_request, valid_session(:user_id => topic.user.to_param)
	end	

	context "oauth authentication" do
		context "with delete access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_any_data")
			end

			context "when the field exists" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 204
				end

				it "deletes the Field" do
		          expect {
		            response = process_oauth_request(@access_grant,@topic)
		          }.to change(Sensit::Topic::Field, :count).by(-1)
		        end

		        it "removes that field from the elastic_search index"

			end

			context "when the field does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_delete @access_grant, "/api/topics/1/fields/1", valid_request, valid_session(:user_id => @user.to_param)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end

			context "deleting a field from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @access_grant.application)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 204
				end
			end

			context "deleting a field owned by another user" do
				before(:each) do
					@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
					another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: another_user, application: @access_grant.application)
				end
				after(:each) do
					@client.indices.flush(index: "another_user", refresh: true)
				end	
				it "cannot read data from another user" do
					expect{
						response = process_oauth_request(@access_grant, @topic)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end				
		end

		context "with delete access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "manage_application_data")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: @application)
			end
			it "cannot read data to another application" do
				expect{
					response = process_oauth_request(@access_grant, @topic)
					response.status.should == 404
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end		
	end
	context "no authentication" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user, application: nil)
		end
		it "is unauthorized" do
			status = process_request(@topic)
			status.should == 401
		end
	end	

end