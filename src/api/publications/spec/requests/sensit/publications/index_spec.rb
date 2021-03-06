require 'spec_helper'
describe "GET sensit/publications#index" do

	def url(topic, format = "json")
		"/api/topics/#{topic.to_param}/publications.#{format}"
	end

	def process_oauth_request(access_grant,topic, params = {}, format = "json")
		oauth_get access_grant, url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	def process_request(topic, params = {}, format = "json")
		get url(topic, format), valid_request(params), valid_session(:user_id => topic.user.to_param)
	end	


	context "oauth authentication" do
		context "with write access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_publications")
			end

			context "with no publications" do
				before(:each) do
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
				end
				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.body.should be_json_eql("{\"publications\": []}")
				end
			end
			context "with 1 publication" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
					@publication = FactoryGirl.create(:publication, :topic => @topic)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.body.should be_json_eql("{\"publications\": [{\"host\": \"#{@publication.host}\", \"protocol\": \"#{@publication.protocol}\"}]}")
				end
			end
			context "with > 1 publication" do
				before(:each) do
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @access_grant.application)
					@publications = [
						FactoryGirl.create(:publication, host: "broker1.cloudmqtt.com", :topic => @topic), 
						FactoryGirl.create(:publication, host: "broker2.cloudmqtt.com", :topic => @topic), 
						FactoryGirl.create(:publication, host: "broker3.cloudmqtt.com", :topic => @topic)
					]
				end

				it "returns all the associated publications" do
					response = process_oauth_request(@access_grant,@topic)
					pub_arr = @publications.inject([]) do |arr,publication|
						arr << "{\"host\": \"#{publication.host}\", \"protocol\": \"#{publication.protocol}\"}"
					end
					response.body.should be_json_eql("{\"publications\": [#{pub_arr.join(",")}]}")
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic, {page:3, per:1})
					response.body.should be_json_eql("{\"publications\": [{\"host\": \"#{@publications[2].host}\", \"protocol\": \"#{@publications[2].protocol}\"}]}")
				end
			end

			context "reading publications from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic_with_feeds, user: @user, application: @application)
					@publication = FactoryGirl.create(:publication, :topic => @topic)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
					response.body.should be_json_eql("{\"publications\": [{\"host\": \"#{@publication.host}\", \"protocol\": \"#{@publication.protocol}\"}]}")
				end
			end

			context "with a publication owned by another user" do
				before(:each) do
					@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
					another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					@publication = FactoryGirl.create(:publication, :topic => @topic)
				end
				after(:each) do
					@client.indices.flush(index: "another_user", refresh: true)
				end					
				it "cannot read data from another user" do
					response = process_oauth_request(@access_grant, @topic)
					response.body.should be_json_eql("{\"publications\": []}")
				end
			end		
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_publications")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic, user: @user, application: @application)
				publication = FactoryGirl.create(:publication, :topic => @topic)
			end
			it "cannot read data of other application" do
				response = process_oauth_request(@access_grant, @topic)
				response.body.should be_json_eql("{\"publications\":[]}")
			end
		end
	end

	context "no authentication" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user, application: nil)
		end
		it "is unauthorized" do
			status = process_request(@topic)
			status.should == 401
		end
	end		
end
