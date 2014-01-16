require 'spec_helper'

describe "sensit/percolators/index" do
  context "when percolator is incomplete" do
    before(:each) do
      @percolators = [
        ::Sensit::Topic::Percolator.create({ topic_id: "topic_type", user_id: @user.to_param, name: "3", query: { query: { query_string: { query: 'foo' } } } }),
        ::Sensit::Topic::Percolator.create({ topic_id: "topic_type", user_id: @user.to_param, name: "4", query: { query: { query_string: { query: 'bar' } } } })
      ]
      assign(:percolators, @percolators)
    end
    it "includes the json show template" do
      render
      json_percolators = @percolators.inject([]) do |arr, percolator|
        arr << Rabl.render(percolator, 'sensit/percolators/show', :view_path => 'app/views')
      end
      json = "{\"percolators\":[" + json_percolators.join(",") + "]}"
      rendered.should  == json
    end
  end
end
