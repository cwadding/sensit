module Sensit
  class Unit < ActiveRecord::Base
  	has_many :sensors, class_name: "Device::Sensor"
  end
end
