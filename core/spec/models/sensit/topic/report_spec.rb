require 'spec_helper'

module Sensit
  describe Topic::Report do

	it {should belong_to :topic}

	it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:topic_id) }

    it { should validate_presence_of(:query) }

  end
end
