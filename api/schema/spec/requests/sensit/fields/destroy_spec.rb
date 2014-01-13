require 'spec_helper'
describe "DELETE sensit/fields#destroy" do

	def process_request(topic)
		field = topic.fields.first
		delete "/api/topics/#{topic.to_param}/fields/#{field.to_param}", valid_request, valid_session(:user_id => topic.user.to_param)
	end

	context "when the field exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user)
		end
		it "is successful" do
			status = process_request(@topic)
			status.should == 204
		end

		it "deletes the Field" do
          expect {
            process_request(@topic)
          }.to change(Sensit::Topic::Field, :count).by(-1)
        end

        it "removes that field from the elastic_search index"

	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/topics/1/fields/1", valid_request, valid_session(:user_id => @user.to_param)
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end
	end


end