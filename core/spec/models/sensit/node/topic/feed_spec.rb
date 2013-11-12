require 'spec_helper'

module Sensit
  describe Node::Topic::Feed do
    it {should belong_to :topic}
    it {should have_many(:data_rows).dependent(:destroy)}

	it { should validate_presence_of(:at) }
  end
end
