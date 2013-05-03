require 'spec_helper'

module Sensit
  describe Measurement do
    it {should belong_to :unit}
    it {should belong_to :sensor}
  end
end
