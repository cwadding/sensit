require 'spec_helper'
describe "GET sensit/percolators#index" do

	def url(topic,format = "json")
		"/api/topics/#{topic.to_param}/percolators.#{format}"
	end

	def process_oauth_request(access_grant,topic,format = "json")
		oauth_get access_grant, url(topic,format), valid_request, valid_session(user_id:topic.user.to_param)
	end

	def process_request(topic,format = "json")
		get url(topic,format), valid_request, valid_session(user_id:topic.user.to_param)
	end


	context "oauth authentication" do
		context "with write access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_percolations")
			end

			context "with 1 percolator" do
				before(:each) do
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
					client = ::Elasticsearch::Client.new
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "10", query: { query: { query_string: { query: 'foo' } } } })
					client.indices.refresh(index: ELASTIC_INDEX_NAME)
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
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@topic)
					response.status.should == 200
					response.body.should be_json_eql("{\"percolators\": [{\"name\":\"#{@percolator.name}\",\"query\":#{@percolator.query.to_json}}]}")
				end
			end

			context "with a percolation owned by another user" do
				before(:each) do
					another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					@percolator = ::Sensit::Topic::Percolator.create({ topic: topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
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
				@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
			end
			it "cannot read data to another application" do
				response = process_oauth_request(@access_grant, @percolator)
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
