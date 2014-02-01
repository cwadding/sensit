require 'spec_helper'

describe "sensit/reports/show" do
  before(:each) do
    @report = assign(:report, FactoryGirl.create(:report, :topic => FactoryGirl.create(:topic, user: @user)))
  end
  it "renders the json data" do
    render
    [:name, :query, :facets].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end