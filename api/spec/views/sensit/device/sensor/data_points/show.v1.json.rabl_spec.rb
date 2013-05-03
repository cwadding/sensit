require 'spec_helper'

describe "sensit/device/sensor/data_points/show" do
  before(:each) do
    @data_point = assign(:data_point, FactoryGirl.build_stubbed(:data_point))
  end
  it "renders the json data" do
    render
    [:sensor_id, :at, :value].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end