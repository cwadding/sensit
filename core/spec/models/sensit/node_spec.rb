require 'spec_helper'

module Sensit
  describe Node do
    it {should have_many(:topics).dependent(:destroy)}
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
