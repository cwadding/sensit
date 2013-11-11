require 'spec_helper'

describe "sensit/nodes/topics/feeds/show" do
  before(:each) do
  	topic = FactoryGirl.create(:topic_with_feeds_and_fields)
    @feed = assign(:feed, topic.feeds.first)
  end
  it "renders the json data" do
    render
    puts "sensit/nodes/topics/feeds/show: #{rendered}"
    [:id, :at, :data].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end