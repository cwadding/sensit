require 'spec_helper'

describe "sensit/percolators/show" do
  before(:each) do
  	@percolator = assign(:feed, ::Sensit::Topic::Percolator.create({ type: ELASTIC_SEARCH_INDEX_TYPE, id: "3", body: { query: { query_string: { query: 'foo' } } } }))
  end
  it "renders the json data" do
    render
    [:id, :body].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end