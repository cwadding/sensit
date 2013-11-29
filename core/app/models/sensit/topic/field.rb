module Sensit
  class Topic::Field < ActiveRecord::Base
  	belongs_to :topic
  	belongs_to :unit

	validates_associated :topic
	validates :name, presence: true, uniqueness: {scope: :topic_id}
	validates :key, presence: true, uniqueness: {scope: :topic_id}
  end
end
