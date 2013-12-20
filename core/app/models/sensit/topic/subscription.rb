module Sensit
  class Topic::Subscription < ActiveRecord::Base
  	belongs_to :topic

	validates_associated :topic

	validates :name, presence: true, uniqueness:  {scope: :topic_id}
	validates :host, presence: true
	# validates :auth_token, presence: true
	# validates :protocol, presence: true

  end
end
