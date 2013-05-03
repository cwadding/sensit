require 'spec_helper'

describe "sensit/device/sensor/data_points/index" do
  context "when data_point is incomplete" do
    before(:each) do
      @data_points = [
        FactoryGirl.build(:data_point),
        FactoryGirl.build(:data_point)
      ]
      assign(:data_points, @data_points)
    end
    it "includes the json show template" do
      render
      @data_points.each do |data_point|
        json_data_point = Rabl.render(data_point, 'sensit/device/sensor/data_points/show', :view_path => 'app/views')
        rendered.should match(json_data_point)
      end
    end
  end
end
