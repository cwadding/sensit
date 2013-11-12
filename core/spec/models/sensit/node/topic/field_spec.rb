require 'spec_helper'

module Sensit
  describe Node::Topic::Field do
  	it {should belong_to :unit}
    it {should belong_to :topic}

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:topic_id) }
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key).scoped_to(:topic_id) }    
    
  end
end
