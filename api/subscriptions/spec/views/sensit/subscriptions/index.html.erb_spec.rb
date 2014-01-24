require 'spec_helper'

describe "sensit/subscriptions/index" do
  context "when subscription is incomplete" do
    before(:each) do
      @topic = FactoryGirl.create(:topic, :user => @user, application: @application)
      @subscriptions = [
        FactoryGirl.create(:subscription, topic: @topic),
        FactoryGirl.create(:subscription, topic: @topic)
      ]
      assign(:subscriptions, @subscriptions)
    end
    it "includes the json show template" do
      render
      json_subscriptions = @subscriptions.inject([]) do |arr, subscription|
        arr << Rabl.render(subscription, 'sensit/subscriptions/show', :view_path => 'app/views')
      end
      json = "{\"subscriptions\":[" + json_subscriptions.join(",") + "]}"
      rendered.should  == json
    end
  end
end

