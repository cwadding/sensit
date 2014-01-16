require 'spec_helper'

describe "sensit/reports/index" do
  context "when report is incomplete" do
    before(:each) do
      @reports = [
        FactoryGirl.create(:report, :topic => FactoryGirl.create(:topic, user: @user)),
        FactoryGirl.create(:report, :topic => FactoryGirl.create(:topic, user: @user))
      ]
      assign(:reports, @reports)
    end
    it "includes the json show template" do
      render
      json_reports = @reports.inject([]) do |arr, report|
        arr << Rabl.render(report, 'sensit/reports/show', :view_path => 'app/views')
      end
      json = "{\"reports\":[" + json_reports.join(",") + "]}"
      rendered.should  == json
    end
  end
end
