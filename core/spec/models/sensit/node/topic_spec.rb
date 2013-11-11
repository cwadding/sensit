require 'spec_helper'

module Sensit
  describe Node::Topic do
    it {should belong_to :node}
    it {should have_many :feeds}
    it {should have_many :fields}
  end
end
