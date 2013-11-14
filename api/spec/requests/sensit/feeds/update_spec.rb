require 'spec_helper'
describe "PUT sensit/feeds#update" do

	before(:each) do
		@node = FactoryGirl.create(:complete_node)
		@topic = @node.topics.first
		@feed = @topic.feeds.first
	end


	def process_request(node, params)
		topic = node.topics.first
		feed = topic.feeds.first
		put "/api/nodes/#{node.id}/topics/#{topic.id}/feeds/#{feed.id}", valid_request(params), valid_session
	end

	context "with correct attributes" do
		before(:all) do
			@params = {
				:feed => {
					:at => Time.new(2002, 10, 31, 2, 2, 2, "+02:00")
				}
			}
		end
		
		it "returns a 200 status code" do
			status = process_request(@node, @params)
			status.should == 200
		end

		it "returns the expected json" do
			process_request(@node, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"at\": #{@params['feed']['at'].to_s},\"data\": [{\"key42\": \"Value42\"}],\"fields\": [{\"key\": \"key37\",\"name\": \"Field37\"}]}")
		end

		it "updates a Feed" do
			process_request(@node, @params)
			updated_field = Sensit::Node::Topic::Feed.find(@feed.id)
			updated_field.at.should == Time.new(2002, 10, 31, 2, 2, 2, "+02:00")
		end
	end		
end