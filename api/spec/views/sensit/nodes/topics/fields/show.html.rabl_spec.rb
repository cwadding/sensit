require 'spec_helper'

describe "sensit/nodes/topics/fields/show" do
  before(:each) do
    @field = assign(:field, FactoryGirl.build_stubbed(:field))
  end
  it "renders the json data" do
    render
    puts "sensit/nodes/topics/fields/show: #{rendered}"
    [:key, :name].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end