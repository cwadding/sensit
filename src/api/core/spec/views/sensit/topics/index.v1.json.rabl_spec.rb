require 'spec_helper'

describe "sensit/topics/index" do
  context "when topic is incomplete" do
    before(:each) do
      @topics = [
        FactoryGirl.create(:topic, user: @user),
        FactoryGirl.create(:topic, user: @user)
      ]
      assign(:topics, @topics)
    end
    # it "includes the json show template" do
      # render
      # json_topics = @topics.inject([]) do |arr, topic|
      #   arr << Rabl.render(topic, 'sensit/topics/show', :view_path => 'app/views')
      # end
      # json = "{\"topics\":[" + json_topics.join(",") + "]}"
      # rendered.should  == json
    # end
  end
end
