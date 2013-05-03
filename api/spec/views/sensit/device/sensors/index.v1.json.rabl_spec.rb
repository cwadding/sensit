require 'spec_helper'

describe "sensit/device/sensors/index" do
  context "when sensor is incomplete" do
    before(:each) do
      @sensors = [
        FactoryGirl.build(:sensor),
        FactoryGirl.build(:sensor)
      ]
      assign(:sensors, @sensors)
    end
    it "includes the json show template" do
      render
      @sensors.each do |sensor|
        json_sensor = Rabl.render(sensor, 'sensit/device/sensors/show', :view_path => 'app/views')
        rendered.should match(json_sensor)
      end
    end
  end
end
