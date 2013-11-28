require 'spec_helper'

describe "sensit/percolators/index" do
  before(:each) do
    assign(:percolators, [
      stub_model(Sensit::Node::Percolator),
      stub_model(Sensit::Node::Percolator)
    ])
  end

  it "renders a list of percolators" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
