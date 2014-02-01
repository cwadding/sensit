require 'spec_helper'
describe "DELETE sensit/percolators#destroy" do


	def url(percolator, format ="json")
		"/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.name}"
	end

	def process_oauth_request(access_grant,percolator, format ="json")
		oauth_delete access_grant, url(percolator, format), valid_request(format: format), valid_session( user_id: percolator.topic.user.to_param)
	end

	def process_request(percolator, format ="json")
		delete url(percolator, format), valid_request(format: format), valid_session( user_id: percolator.topic.user.to_param)
	end

	context "oauth authentication" do
		context "with delete access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_any_percolations")
			end
			context "when the percolator exists" do
				before(:each) do
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
				end

				it "is successful" do
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "3", query: { query: { query_string: { query: 'foo' } } } })
					response = process_oauth_request(@access_grant,@percolator)
					response.status.should == 204
				end

				it "deletes the Percolator" do
					client = ::Elasticsearch::Client.new
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, name: "3", query: { query: { query_string: { query: 'foo' } } } })
					client.indices.refresh(index: ELASTIC_INDEX_NAME)
					expect {
						response = process_oauth_request(@access_grant,@percolator)
						client.indices.refresh(index: ELASTIC_INDEX_NAME)
					}.to change{::Sensit::Topic::Percolator.count({ topic_id: @topic.to_param, user_id: @user.name})}.by(-1)
		        end

		 #        it "removes that feed from the elastic_search index"

			end

			context "when the percolator does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_delete @access_grant, "/api/topics/1/percolators/1", valid_request, valid_session
						response.status.should == 404
					}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end

			context "deleting percolation from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					@topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@percolator)
					response.status.should == 204
				end
			end

			context "deleting a percolation owned by another user" do
				before(:each) do
					another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					@percolator = ::Sensit::Topic::Percolator.create({ topic: topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
				end
				it "cannot read data from another user" do
					expect{
						response = process_oauth_request(@access_grant, @percolator)
						response.status.should == 404
					}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end
		end

		context "with delete access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_application_percolations")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic, user: @user, application: @application)
				@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
			end
			it "cannot read data to another application" do
				expect{
					response = process_oauth_request(@access_grant, @percolator)
					response.status.should == 404
				}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			end
		end
	end
	context "no authentication" do
		before(:each) do
			topic = FactoryGirl.create(:topic, user: @user, application: nil)
			@percolator = ::Sensit::Topic::Percolator.create({ topic: topic, :name => "5",  query: { query: { query_string: { query: 'foo' } } } })
		end
		it "is unauthorized" do
			status = process_request(@percolator)
			status.should == 401
		end
	end		
end