require 'spec_helper'
describe "GET sensit/subscriptions#index" do

	def url(format = "json")
		"/api/subscriptions.#{format}"
	end

	def process_oauth_request(access_grant,format = "json")
		oauth_get access_grant, url(format), valid_request, valid_session
	end

	def process_request(format = "json")
		get url(format), valid_request, valid_session
	end	

	context "oauth authentication" do
		context "with write access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_subscriptions")
			end			
			context "with a subscription" do
				before(:each) do
					@subscription = FactoryGirl.create(:subscription, :user => @user, application: @access_grant.application)
				end
				it "is successful" do
					response = process_oauth_request(@access_grant)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant)
					response.body.should be_json_eql("{\"subscriptions\": [{\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\",\"protocol\": \"#{@subscription.protocol}\"}]}")
				end
			end
			context "with no subscriptions" do
				it "returns the expected json" do
					response = process_oauth_request(@access_grant)
					response.body.should be_json_eql("{\"subscriptions\": []}")
				end
			end			
			context "reading subscriptions from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@subscription = FactoryGirl.create(:subscription, user: @user, application: @application)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant)
					response.status.should == 200
					response.body.should be_json_eql("{\"subscriptions\": [{\"name\": \"#{@subscription.name}\",\"host\": \"#{@subscription.host}\",\"protocol\": \"#{@subscription.protocol}\"}]}")
				end
			end

			context "with a subscription owned by another user" do
				before(:each) do
					@client = ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new
					@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
					another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@subscription = FactoryGirl.create(:subscription, user: another_user, application: @access_grant.application)
				end
				after(:each) do
					@client.indices.flush(index: "another_user", refresh: true)
				end	
				it "cannot read data from another user" do
					response = process_oauth_request(@access_grant)
					response.body.should be_json_eql("{\"subscriptions\": []}")
				end
			end				
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_subscriptions")
				@application = FactoryGirl.create(:application)
				@subscription = FactoryGirl.create(:subscription, user: @user, application: @application)
			end
			it "cannot read data of other application" do
				response = process_oauth_request(@access_grant)
				response.body.should be_json_eql("{\"subscriptions\":[]}")
			end
		end		
	end
	context "no authentication" do
		it "is unauthorized" do
			status = process_request
			status.should == 401
		end
	end		
end
