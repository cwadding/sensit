require 'spec_helper'

module Sensit
  describe Topic do
    it {should have_many(:subscriptions).dependent(:destroy)}
  end
end
