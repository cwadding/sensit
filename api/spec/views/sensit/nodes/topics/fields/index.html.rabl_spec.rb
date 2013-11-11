require 'spec_helper'

describe "sensit/nodes/topics/fields/index" do
  context "when feed is incomplete" do
    before(:each) do
      @fields = [
        FactoryGirl.create(:field),
        FactoryGirl.create(:field)
      ]
      assign(:fields, @fields)
    end
    it "includes the json show template" do
      render
      json_fields = @fields.inject([]) do |arr, field|
        arr << Rabl.render(field, 'sensit/nodes/topics/fields/show', :view_path => 'app/views')
      end
      json = "{\"fields\":[" + json_fields.join(",") + "]}"
      rendered.should  == json
    end
  end
end
