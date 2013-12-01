require 'spec_helper'

module Sensit
  describe Topic::Subscription do

	it {should belong_to :topic}

	it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:topic_id) }

    it { should validate_presence_of(:host) }
  end
end
