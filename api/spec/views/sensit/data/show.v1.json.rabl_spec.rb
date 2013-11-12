require 'spec_helper'

describe "sensit/data/show" do
  before(:each) do
    @data = assign(:feed, FactoryGirl.create(:data_row))
  end
  it "renders the json data" do
    render
    puts "sensit/data/show: #{rendered}"
    [:value].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end