require 'spec_helper'

module Sensit
  describe Node::Topic::Field do
  	it {should belong_to :unit}
    it {should belong_to :topic}
  end
end
