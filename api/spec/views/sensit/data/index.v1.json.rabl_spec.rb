require 'spec_helper'

describe "sensit/data/index" do
  context "when feed is incomplete" do
    before(:each) do
      @values = [
        FactoryGirl.create(:data_row),
        FactoryGirl.create(:data_row)
      ]
      assign(:data, @data)
    end
    # it "includes the json show template" do
    #   render
    #   json_values = @data.inject([]) do |arr, data|
    #     arr << "{\"#{data.key}\":\"#{data.value}\"}"
    #   end
    #   json = "{\"data\":[" + json_data.join(",") + "]}"
    #   rendered.should  == json
    # end
  end
end
