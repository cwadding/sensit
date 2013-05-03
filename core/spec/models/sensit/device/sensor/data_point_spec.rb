require 'spec_helper'

module Sensit
  describe Device::Sensor::DataPoint do
    it {should belong_to :sensor}
  end
end
