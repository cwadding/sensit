require 'spec_helper'
describe "PUT sensit/fields#update" do

	before(:each) do
		@topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user)
		@field = @topic.fields.first
	end


	def process_request(topic, params)
		field = topic.fields.first
		put "/api/topics/#{topic.to_param}/fields/#{field.to_param}", valid_request(params), valid_session(:user_id => topic.user.to_param)
	end

	context "with correct attributes" do
		before(:all) do
			@params = {
				:field => {
					:name => "New field name"
				}
			}
		end
		
		it "returns a 200 status code" do
			status = process_request(@topic, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@topic, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"key\": \"#{@field.key}\",\"name\": \"New field name\"}")
		end

		it "updates a Field" do
			process_request(@topic, @params)
			updated_field = Sensit::Topic::Field.find(@field.id)
			updated_field.name.should == "New field name"
		end
	end	
end