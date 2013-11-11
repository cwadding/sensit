require 'spec_helper'

module Sensit
  describe Node::Topic::Feed::DataRow do
    it {should belong_to :feed}
  end
end
