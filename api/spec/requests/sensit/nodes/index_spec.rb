require 'spec_helper'
describe "GET sensit/nodes#index" do

	def process_request(params = {})
		get "/api/nodes", valid_request(params), valid_session
	end


	context "when the node exists" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
		end
		it "is successful" do
			status = process_request
			status.should == 200
		end

		# it "returns the expected json" do
		# 	process_request
		# 	response.body.should be_json_eql("{\"nodes\": [{\"description\": null,\"name\": \"Node55\",\"topics\": [{\"description\": null,\"feeds\": [{\"data\": [{\"key117\": \"Value117\"}]}],\"fields\": [{\"key\": \"key112\",\"name\": \"Field112\"}],\"name\": \"Topic122\"},{\"description\": null,\"feeds\": [{\"data\": [{\"key118\": \"Value118\"}]}],\"fields\": [{\"key\": \"key113\",\"name\": \"Field113\"}],\"name\": \"Topic123\"},{\"description\": null,\"feeds\": [{\"data\": [{\"key119\": \"Value119\"}]}],\"fields\": [{\"key\": \"key114\",\"name\": \"Field114\"}],\"name\": \"Topic124\"}]}]}")
		# end
	end

end
