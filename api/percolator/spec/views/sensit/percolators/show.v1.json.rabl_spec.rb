require 'spec_helper'

describe "sensit/percolators/show" do
  before(:each) do
  	@percolator = assign(:feed, FactoryGirl.create(:percolator))
  end
  it "renders the json data" do
    render
    [:id, :body].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end