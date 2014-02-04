require 'spec_helper'

describe "sensit/feeds/show" do
  before(:each) do
    topic = FactoryGirl.create(:topic_with_feeds_and_fields, user: @user)
    @feed = assign(:feed, topic.feeds.first)
  end
  it "renders the json data" do
    render
    [:id, :at, :tz, :data].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end