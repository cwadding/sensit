require 'spec_helper'
describe "GET sensit/topics#index" do

  	def process_request(node)
		get "/api/nodes/#{node.id}/topics/", valid_request, valid_session
	end

	context "when the topic exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 200
		end

		# it "returns the expected json" do
		# 	process_request(@node)
		# 	response.body.should be_json_eql('{"topics": [{"description": null,"feeds": [{"data": [{"key138": "Value138"}]}],"fields": [{"key": "key133","name": "Field133"}],"name": "Topic143"},{"description": null,"feeds": [{"data": [{"key139": "Value139"}]}],"fields": [{"key": "key134","name": "Field134"}],"name": "Topic144"},{"description": null,"feeds": [{"data": [{"key140": "Value140"}]}],"fields": [{"key": "key135","name": "Field135"}],"name": "Topic145"}]}')          
		# end  
	end
end