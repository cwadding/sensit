module Sensit
  class Device::Sensor < ActiveRecord::Base
  	belongs_to :device
  	belongs_to :unit
  	has_many :data_points
  end
end
