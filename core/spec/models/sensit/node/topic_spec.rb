require 'spec_helper'

module Sensit
  describe Node::Topic do
    it {should belong_to :node}
    it {should have_many(:feeds).dependent(:destroy)}
    it {should have_many(:fields).dependent(:destroy)}

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:node_id) }
  end
end
