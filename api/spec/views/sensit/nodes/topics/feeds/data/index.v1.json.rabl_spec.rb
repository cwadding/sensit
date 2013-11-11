require 'spec_helper'

describe "sensit/nodes/topics/feeds/data/index" do
  context "when feed is incomplete" do
    before(:each) do
      @data = [
        FactoryGirl.create(:data_row),
        FactoryGirl.create(:data_row)
      ]
      assign(:data, @data)
    end
    it "includes the json show template" do
      render
      json_data = @data.inject([]) do |arr, data|
        arr << "{\"#{data.key}\":\"#{data.value}\"}"
      end
      json = "{\"data\":[" + json_data.join(",") + "]}"
      rendered.should  == json
    end
  end
end
