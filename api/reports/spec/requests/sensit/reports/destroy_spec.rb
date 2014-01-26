require 'spec_helper'
describe "DELETE sensit/reports#destroy" do

	def process_oauth_request(access_grant,report)
		oauth_delete access_grant, "/api/topics/#{report.topic_id}/reports/#{report.id}", valid_request, valid_session(:user_id => report.topic.user.to_param)
	end

	before(:each) do
		@access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "delete_any_reports")
	end

	context "when the report exists" do
		before(:each) do
			@report = FactoryGirl.create(:report, :topic => FactoryGirl.create(:topic, user: @user, application: @access_grant.application))
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

 #        it "removes that feed from the elastic_search index"

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
end