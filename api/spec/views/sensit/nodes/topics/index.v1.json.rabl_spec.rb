require 'spec_helper'

describe "sensit/nodes/topics/index" do
  context "when topic is incomplete" do
    before(:each) do
      @topics = [
        FactoryGirl.create(:topic),
        FactoryGirl.create(:topic)
      ]
      assign(:topics, @topics)
    end
    it "includes the json show template" do
      render
      json_topics = @topics.inject([]) do |arr, field|
        arr << Rabl.render(field, 'sensit/nodes/topics/show', :view_path => 'app/views')
      end
      json = "{\"topics\":[" + json_topics.join(",") + "]}"
      rendered.should  == json
    end
  end
end
