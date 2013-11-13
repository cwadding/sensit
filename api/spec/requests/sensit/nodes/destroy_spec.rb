require 'spec_helper'
describe "DELETE sensit/nodes#destroy" do

	def process_request(node)
		delete "/api/nodes/#{node.id}", valid_request, valid_session
	end

	context "when the node exists" do
		before(:each) do
			@node = FactoryGirl.create(:node)
		end
		it "is successful" do
			status = process_request(@node)
			status.should == 204
		end

		it "deletes the Node" do
          expect {
            process_request(@node)
          }.to change(Sensit::Node, :count).by(-1)
        end
	end

	context "when the node is complete" do
		before(:each) do
			@node = FactoryGirl.create(:complete_node)
		end
		it "deletes its topics" do
			number_of_topics = @node.topics.count
			number_of_topics.should > 0
          expect {
            process_request(@node)
          }.to change(Sensit::Node::Topic, :count).by(-1*number_of_topics)
        end
	end	

	context "when the node does not exists" do
		it "is unsuccessful" do
			expect{
				status = delete "/api/nodes/3", valid_request, valid_session
			}.to raise_error(ActiveRecord::RecordNotFound)
			#status.should == 404
		end
	end

end