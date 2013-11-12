require 'spec_helper'

describe "sensit/fields/show" do
  before(:each) do
    @field = assign(:field, FactoryGirl.build_stubbed(:field))
  end
  it "renders the json data" do
    render
    puts "sensit/fields/show: #{rendered}"
    [:key, :name].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end