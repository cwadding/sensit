require 'spec_helper'

describe "sensit/topics/show" do
  before(:each) do
    @topic = assign(:topic, FactoryGirl.create(:topic_with_feeds, user: @user, application: @application))
  end
  it "renders the json data" do
    render
    [:id, :name, :description, :feeds].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end