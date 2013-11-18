require 'spec_helper'

describe "sensit/data/show" do
  before(:each) do
    @values = assign(:feed, FactoryGirl.create(:data_row))
  end
  # it "renders the json data" do
  #   render
  #   [:value].each do |key|
  #     rendered.should have_json_path("#{key.to_s}")
  #   end
  # end
end