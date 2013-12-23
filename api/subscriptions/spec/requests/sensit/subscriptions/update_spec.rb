require 'spec_helper'
describe "PUT sensit/subscriptions#update" do

	before(:each) do
		@subscription = ::Sensit::Topic::Subscription.create({ :name => "MyString", :host => "127.0.0.1", :topic_id => 1})
	end


	def process_request(subscription, params)
		put "/api/topics/#{subscription.type}/subscriptions/#{subscription.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do

		before(:each) do
			@params = {
				:subscription => {
					:name => "MyNewString",
					:host => "localhost"
				}
			}
		end
		it "returns a 200 status code" do
			status = process_request(@subscription, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@subscription, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"id\":\"#{@subscription.id}\",\"name\": \"MyNewString\",\"host\": \"localhost\"")
		end
	end
end