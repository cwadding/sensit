module Sensit
  class Node < ActiveRecord::Base
  	has_many :topics
  end
end
