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
					:at => Time.new(2002, 10, 31, 2, 2, 2, "+00:00")
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

			topic = @node.topics.first
			feed = topic.feeds.first
			field_arr = topic.fields.inject([]) do |arr, field|
				arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
			end
			data_arr = feed.data_rows.inject([]) do |arr, datum|
				arr << "{\"#{datum.key}\": \"#{datum.value}\"}"
			end
			response.body.should be_json_eql("{\"at\": \"#{@params[:feed][:at].strftime("%Y-%m-%dT%H:%M:%S.000Z")}\",\"data\": [#{data_arr.join(',')}],\"fields\": [#{field_arr.join(',')}]}")
		end

		it "updates a Feed" do
			process_request(@node, @params)
			updated_field = Sensit::Node::Topic::Feed.find(@feed.id)
			updated_field.at.should == @params[:feed][:at]
		end
	end		
end