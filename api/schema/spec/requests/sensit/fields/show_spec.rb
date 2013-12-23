require 'spec_helper'
describe "GET sensit/fields#show" do

	def process_request(topic)
		field = @topic.fields.first
		get "/api/topics/#{topic.to_param}/fields/#{field.to_param}", valid_request, valid_session
	end

	context "when the field exists" do
		before(:each) do
			@topic = FactoryGirl.create(:topic_with_feeds_and_fields)
		end
		it "is successful" do
			status = process_request(@topic)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@topic)
			field = @topic.fields.first
			response.body.should be_json_eql("{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}")
		end
	end

	context "when the field does not exist" do
		it "is unsuccessful" do
			expect{
				status = get "/api/topics/1/fields/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			
			#status.should == 404
		end

		it "returns the expected json" do
			expect{
				get "/api/topics/1/fields/1", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#response.body.should be_json_eql("{\"id\":1,\"name\":\"Test node\",\"description\":\"A description of my node\",\"topics\":[]}")
		end
	end  
end

