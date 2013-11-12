module Sensit
  class Node < ActiveRecord::Base
  	has_many :topics, dependent: :destroy

  	validates :name, presence: true, uniqueness: true
  end
end
