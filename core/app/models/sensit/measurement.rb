module Sensit
  class Measurement < ActiveRecord::Base
  	belongs_to :sensor, class_name: "Device::Sensor"
  	belongs_to :unit
  end
end
