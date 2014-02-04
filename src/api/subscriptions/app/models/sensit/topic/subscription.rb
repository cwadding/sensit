module Sensit
  class Topic::Subscription < ActiveRecord::Base
  	extend ::FriendlyId
	friendly_id :name, use: [:slugged, :finders]
	
	has_secure_password :validations => false
  	
  	belongs_to :topic

	validates_associated :topic
	validates :name, presence: true, uniqueness:  {scope: :topic_id}
	validates :host, presence: true
	validates :protocol, presence: true
	validates :port, numericality: { only_integer: true, greater_than: 0, less_than:49152}, allow_nil: true
	# validates :auth_token, presence: true
	# validates :protocol, presence: true
	def uri=(value)
		url = ::URI.parse value
		self.protocol = url.scheme
		self.host = url.host
		self.port = url.port
		self.username = url.user
		self.password = url.password
	end

	def uri
		"#{self.protocol}://#{self.username}:#{self.password}@#{self.host}:#{self.port}"
	end

  end
end
