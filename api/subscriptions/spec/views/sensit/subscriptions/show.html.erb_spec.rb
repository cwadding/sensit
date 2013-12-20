require 'spec_helper'

describe "sensit/subscriptions/show" do
  before(:each) do
    @subscription = assign(:subscription, FactoryGirl.build_stubbed(:subscription))
  end
  it "renders the json data" do
    render
    [:name, :host].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end