require 'spec_helper'

describe "sensit/percolators/show" do
  before(:each) do
  	@percolator = assign(:feed, ::Sensit::Topic::Percolator.create({ topic_id: "topic_type", user_id: @user.name, name: "3", query: { query: { query_string: { query: 'foo' } } } }))
  end
  it "renders the json data" do
    render
    [:name, :query].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end