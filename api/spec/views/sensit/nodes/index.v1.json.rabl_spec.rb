require 'spec_helper'

describe "sensit/nodes/index" do
  context "when node is incomplete" do
    before(:each) do
      @nodes = [
        FactoryGirl.create(:complete_node),
        FactoryGirl.create(:complete_node)
      ]
      assign(:nodes, @nodes)
    end
    it "includes the json show template" do
      render
      json_nodes = @nodes.inject([]) do |arr, field|
        arr << Rabl.render(field, 'sensit/nodes/show', :view_path => 'app/views')
      end
      json = "{\"nodes\":[" + json_nodes.join(",") + "]}"
      rendered.should  == json
    end
  end
end
