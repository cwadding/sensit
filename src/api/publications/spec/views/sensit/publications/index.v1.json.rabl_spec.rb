require 'spec_helper'

describe "sensit/publications/index" do
  context "when publication is incomplete" do
    before(:each) do
      @publications = [
        FactoryGirl.create(:publication, :topic => @user),
        FactoryGirl.create(:publication, :topic => @user)
      ]
      assign(:publications, @publications)
    end
    it "includes the json show template" do
      render
      json_publications = @publications.inject([]) do |arr, publication|
        arr << Rabl.render(publication, 'sensit/publications/show', :view_path => 'app/views')
      end
      json = "{\"publications\":[" + json_publications.join(",") + "]}"
      rendered.should  == json
    end
  end
end

