require 'spec_helper'

describe "sensit/publications/show" do
  before(:each) do
    @publication = assign(:publication, FactoryGirl.build_stubbed(:publication))
  end
  it "renders the json data" do
    render
    [:protocol, :host].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end