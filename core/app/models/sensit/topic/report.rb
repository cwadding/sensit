module Sensit
  class Topic::Report < ActiveRecord::Base
  	serialize :query, Hash
  	belongs_to :topic

	validates_associated :topic

	validates :name, presence: true, uniqueness: {scope: :topic_id}
	validates :query, presence: true
  end
end
