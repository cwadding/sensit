require 'spec_helper'

describe "sensit/nodes/show" do
  before(:each) do
  @node = assign(:node, FactoryGirl.create(:complete_node, topics_count: 3))
  end
  it "renders the json data" do
    render
    puts "sensit/nodes/show: #{rendered}"
    [:id, :name, :description].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end
