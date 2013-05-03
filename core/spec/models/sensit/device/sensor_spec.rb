require 'spec_helper'

module Sensit
  describe Device::Sensor do
    it {should belong_to :device}
    it {should belong_to :unit}
    it {should have_many :data_points}
  end
end
