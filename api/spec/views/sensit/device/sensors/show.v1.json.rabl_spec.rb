require 'spec_helper'

describe "sensit/device/sensors/show" do
  before(:each) do
    @sensor = assign(:sensor, FactoryGirl.build_stubbed(:sensor))
  end
  it "renders the json data" do
    render
    [:unit_id, :min_value, :max_value, :start_value, :device_id].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end