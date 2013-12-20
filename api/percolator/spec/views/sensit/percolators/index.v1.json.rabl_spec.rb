require 'spec_helper'

describe "sensit/percolators/index" do
  context "when topic is incomplete" do
    before(:each) do
      @percolators = [
        FactoryGirl.create(:percolator),
        FactoryGirl.create(:percolator)
      ]
      assign(:percolators, @percolators)
    end
    it "includes the json show template" do
      render
      json_percolators = @percolators.inject([]) do |arr, percolator|
        arr << Rabl.render(topic, 'sensit/percolator/show', :view_path => 'app/views')
      end
      json = "{\"percolators\":[" + json_percolators.join(",") + "]}"
      rendered.should  == json
    end
  end
end
