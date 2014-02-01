require 'spec_helper'

describe "sensit/users/show" do
  before(:each) do
    assign(:user, @user)
  end
  it "renders the json data" do
    render
    [:id, :name].each do |key|
      rendered.should have_json_path("#{key.to_s}")
    end
  end
end