require 'spec_helper'

describe "sensit/fields/index" do
  context "when feed is incomplete" do
    before(:each) do
      topic = FactoryGirl.create(:topic, user: @user, application: @application)
      @fields = [
        FactoryGirl.create(:field, topic: topic),
        FactoryGirl.create(:field, topic: topic)
      ]
      assign(:fields, @fields)
    end
    it "includes the json show template" do
      render
      json_fields = @fields.inject([]) do |arr, field|
        arr << Rabl.render(field, 'sensit/fields/show', :view_path => 'app/views')
      end
      json = "{\"fields\":[" + json_fields.join(",") + "]}"
      rendered.should  == json
    end
  end
end
