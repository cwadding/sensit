module Sensit
  class Device::Sensor::DataPoint < ActiveRecord::Base
  	belongs_to :sensor
  end
end
