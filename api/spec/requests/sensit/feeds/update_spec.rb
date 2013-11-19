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

		it "returns the expected json" do
	         fields = @topic.fields.map(&:key)
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => (i+1).to_s)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }

			process_request(@node, params)
			expect(response).to render_template(:show)

			field_arr = @topic.fields.inject([]) do |arr, field|
				arr << "{\"key\": \"#{field.key}\",\"name\": \"#{field.name}\"}"
			end
			values.merge!(@feed.values)
			data_arr = values.inject([]) do |arr, (key, value)|
				arr << "\"#{key}\": \"#{value}\""
			end
			response.body.should be_json_eql("{\"at\": #{@topic.feeds.first.at.utc.to_f},\"data\": {#{data_arr.join(',')}},\"fields\": [#{field_arr.join(',')}]}")
		end

		it "returns a 200 status code" do
			 fields = @topic.fields.map(&:key)
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => i)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }
			status = process_request(@node, params)
			status.should == 200
		end


		it "updates a Feed" do

	         fields = @topic.fields.map(&:key)
	         values = {}
	         fields.each_with_index do |field, i|
	            values.merge!(field => (i+1).to_s)
	         end
	         params = {
	            :feed => {
	               :values => values
	            }
	         }

			process_request(@node, params)
			# updated_field = Sensit::Node::Topic::Feed.find(:index => @feed.index, :index => @feed.type, :id => @feed.id)
			# updated_field.at.utc.to_f.should == params[:feed][:at]
		end
	end		
end