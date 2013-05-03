require 'spec_helper'

describe "sensit/devices/index" do
  context "when device is incomplete" do
    before(:each) do
      @devices = [
        FactoryGirl.build(:device),
        FactoryGirl.build(:device)
      ]
      assign(:devices, @devices)
    end
    it "includes the json show template" do
      render
      @devices.each do |device|
        json_device = Rabl.render(device, 'sensit/devices/show', :view_path => 'app/views')
        rendered.should match(json_device)
      end
    end
  end
end
