require 'spec_helper'
describe "GET sensit/percolators#index" do

	def url(topic,format = "json")
		"/api/topics/#{topic.to_param}/percolators.#{format}"
	end

	def process_oauth_request(access_grant,topic,format = "json")
		oauth_get access_grant, url(topic,format), valid_request, valid_session
	end

	def process_request(topic,format = "json")
		get url(topic,format), valid_request, valid_session
	end


	context "oauth authentication" do
		context "with write access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_percolations")
			end

			context "with 1 percolator" do
				before(:each) do
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "10", query: { query_string: { query: 'foo' } } })
					refresh_index
				end

				it "is successful" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.body.should be_json_eql("{\"percolators\": [{\"name\":\"#{@percolator.name}\",\"query\":#{@percolator.query.to_json}}]}")
				end
			end

			context "with no percolators" do
				before(:each) do
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
				end
				it "returns the expected json" do
					response = process_oauth_request(@access_grant, @topic)
					response.body.should be_json_eql("{\"percolators\":[]}")
				end  				
			end

			context "pagination" do
			end

			context "reading percolation from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query_string: { query: 'foo' } } })
					refresh_index
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
					response.body.should be_json_eql("{\"percolators\": [{\"name\":\"#{@percolator.name}\",\"query\":#{@percolator.query.to_json}}]}")
				end
			end

			context "with a percolation owned by another user" do
				before(:each) do
					@client.indices.create({index: "another_user", :body => {:settings => {:index => {:store => {:type => :memory}}}}}) unless @client.indices.exists({ index: "another_user"})
					another_user = Sensit::User.create(:name => "another_user", :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					@topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query_string: { query: 'foo' } } })
					refresh_index
				end
				after(:each) do
					@client.indices.flush(index: "another_user", refresh: true)
				end
				it "cannot read data from another user" do
					response = process_oauth_request(@access_grant, @topic)
					response.body.should be_json_eql("{\"percolators\":[]}")
				end
			end
		end
		context "with read access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_application_percolations")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic, user: @user, application: @application)
				percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query_string: { query: 'foo' } } })
				refresh_index
			end
			it "cannot read data to another application" do
				response = process_oauth_request(@access_grant, @topic)
				response.body.should be_json_eql("{\"percolators\":[]}")
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
