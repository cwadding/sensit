require 'spec_helper'

describe "sensit/devices/show" do
  before(:each) do
  @device = assign(:device, FactoryGirl.build_stubbed(:device))
  end
  it "renders the json data" do
    render
    [:title, :url, :status, :description, :icon, :user_id, :location_id].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end
