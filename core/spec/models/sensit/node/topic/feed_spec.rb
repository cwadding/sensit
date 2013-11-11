require 'spec_helper'

module Sensit
  describe Node::Topic::Feed do
    it {should belong_to :topic}
    it {should have_many :data_rows}
  end
end
