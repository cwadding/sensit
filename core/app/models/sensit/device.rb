module Sensit
  class Device < ActiveRecord::Base
  	has_many :sensors
  end
end
