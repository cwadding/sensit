require 'spec_helper'

describe "sensit/feeds/index" do
  context "when feed is incomplete" do
    before(:each) do
      topic = FactoryGirl.create(:topic_with_feeds_and_fields)
      @feeds = topic.feeds
      assign(:feeds, @feeds)
    end
    it "includes the json show template" do
      render
      json_feeds = @feeds.inject([]) do |arr, feed|
        arr << Rabl.render(feed, 'sensit/feeds/show', :view_path => 'app/views')
      end
      json = "{\"feeds\":[" + json_feeds.join(",") + "]}"
      rendered.should  == json
    end
  end
end
