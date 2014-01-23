require 'spec_helper'

describe "sensit/topics/show" do
  before(:each) do
    @user = assign(:user, @user)
  end
  it "renders the json data" do
    render
    [:id, :name].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end