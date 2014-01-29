require 'spec_helper'
describe "DELETE sensit/reports#destroy" do

	def url(report, format = "json")
		"/api/topics/#{report.topic_id}/reports/#{report.id}"
	end

	def process_oauth_request(access_grant,report, format = "json")
		oauth_delete access_grant, "/api/topics/#{report.topic.to_param}/reports/#{report.id}", valid_request, valid_session(:user_id => report.topic.user.to_param)
	end

	def process_request(report, format = "json")
		delete "/api/topics/#{report.topic.to_param}/reports/#{report.id}", valid_request, valid_session(:user_id => report.topic.user.to_param)
	end	


	context "oauth authentication" do
		context "with delete access to the users percolator data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_any_reports")
			end

			context "when the report exists" do
				before(:each) do
					@topic = FactoryGirl.create(:topic, user: @user, application: @access_grant.application)
					@report = FactoryGirl.create(:report, :topic => @topic)
				end

				it "is successful" do
					response = process_oauth_request(@access_grant,@report)
					response.status.should == 204
				end

				it "deletes the Report" do
					expect {
						response = process_oauth_request(@access_grant,@report)
					}.to change(Sensit::Topic::Report, :count).by(-1)
		        end
			end

			context "when the report does not exist" do
				it "is unsuccessful" do
					expect{
						response = oauth_delete @access_grant, "/api/topics/1/reports/1", valid_request, valid_session(:user_id => @user.to_param)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
					#
				end
			end

			context "deleting report from another application" do
				before(:each) do
					@application = FactoryGirl.create(:application)
					topic = FactoryGirl.create(:topic, user: @user, application: @application)
					@report = FactoryGirl.create(:report, :topic => topic)
				end

				it "returns the expected json" do
					response = process_oauth_request(@access_grant,@report)
					response.status.should == 204
				end
			end

			context "deleting a report owned by another user" do
				before(:each) do
					another_user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "anouther_user@example.com", :password => "password", :password_confirmation => "password")
					topic = FactoryGirl.create(:topic, user: another_user, application: @access_grant.application)
					@report = FactoryGirl.create(:report, :topic => topic)
				end
				it "cannot read data from another user" do
					expect{
						response = process_oauth_request(@access_grant, @report)
						response.status.should == 404
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end			
		end

		context "with delete access to only the applications data" do
			before(:each) do
				@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_application_reports")
				@application = FactoryGirl.create(:application)
				@topic = FactoryGirl.create(:topic, user: @user, application: @application)
				@report = FactoryGirl.create(:report, :topic => @topic)
			end
			it "cannot read data to another application" do
				expect{
					response = process_oauth_request(@access_grant, @report)
					response.status.should == 404
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end
	end

	context "no authentication" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user, application: nil)
			@report = FactoryGirl.create(:report, :topic => @topic)
		end
		it "is unauthorized" do
			status = process_request(@report)
			status.should == 401
		end
	end		
end