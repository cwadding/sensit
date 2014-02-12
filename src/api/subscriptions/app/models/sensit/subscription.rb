module Sensit
	class Subscription < ActiveRecord::Base
		extend ::FriendlyId
		friendly_id :name, use: [:slugged, :finders]

		has_secure_password :validations => false
		belongs_to :user, class_name: "Sensit::User"
		belongs_to :application, class_name: "::Doorkeeper::Application", foreign_key: "application_id"


		validates :name, presence: true, uniqueness:  {scope: :user_id}
		validates :host, presence: true
		validates :protocol, presence: true
		validates :port, numericality: { only_integer: true, greater_than: 0, less_than:49152}, allow_nil: true

		def uri=(value)
			url = ::URI.parse value
			self.protocol = url.scheme
			self.host = url.host
			self.port = url.port
			self.username = url.user
			self.password = url.password
		end

		def uri
			if (self.username)
				"#{self.protocol}://#{self.username}:#{self.password}@#{self.host}:#{self.port}"
			else
				"#{self.protocol}://#{self.host}:#{self.port}"
			end
		end

		def subscribe
			client.subscribe(self.name) do |topic, message|
				topic = topic || self.name
				# validate message format
				create_feed(message.merge!({index: self.user.name, type: topic}))
			end
		end

		def client
			@client ||= Messenger.parse(uri)
		end


		private

		# def faye_subscribe(subscription)
		# 	# topic_id = subscription.topic_id
		# 	client = Faye::Client.new(subscription.host)

		# 	client.subscribe("/#{subscription.name}") do |feed_params|
				
		# 	end
		# end

		def create_feed(feed_params)
			feed = Topic::Feed.create(feed_params) 
		end


	end
end
