require 'spec_helper'
describe "PUT sensit/percolators#update" do

	def process_request(percolator, params)
		put "/api/topics/#{percolator.topic.to_param}/percolators/#{percolator.name}", valid_request(params), valid_session(:user_id => percolator.topic.user.to_param)
	end

	context "with correct attributes" do
		before(:each) do
			@topic = FactoryGirl.create(:topic, user: @user)
		end
		it "returns a 200 status code" do
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "4",  query: { query: { query_string: { query: 'foo' } } } })
			@params = {
				:percolator => {
					:name => "5",
					:query => { query: { query_string: { query: 'bar' } } }
				}
			}
			status = process_request(@percolator, @params)
			status.should == 200
		end

		it "returns the expected json" do
			@percolator = ::Sensit::Topic::Percolator.create({ topic: @topic, :name => "3", query: { query: { query_string: { query: 'foo' } } } })
			@params = {
				:percolator => {
					:query => { query: { query_string: { query: 'bar' } } }
				}
			}

			process_request(@percolator, @params)
			expect(response).to render_template(:show)
			response.body.should be_json_eql("{\"name\": \"#{@percolator.name}\",\"query\": #{@params[:percolator][:query].to_json}}")
		end
	end
end