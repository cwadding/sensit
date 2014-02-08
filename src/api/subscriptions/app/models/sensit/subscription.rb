module Sensit

	class MQTT
		
		attr_accessor :host, :port, :username, :password

		def initialize()
			
		end

		def uri=(value)
			url = ::URI.parse value
			# raise MQTT::InvalidProtocol  if url.scheme != "mqtt"
			self.host = url.host
			self.port = url.port
			self.username = url.user
			self.password = url.password
		end

		def uri
			"mqtt://#{self.username}:#{self.password}@#{self.host}:#{self.port}"
		end

		def connection_options
			conn_opts = {
				remote_host: self.host,
				remote_port: self.port,
				username: self.user,
				password: self.password,
			}
		end

		def subscribe(name, &block)
			::Thread.new do
				::MQTT::Client.connect(connection_options) do |c|
					# The block will be called when you messages arrive to the topic
					c.get(subscription.name) do |topic, message|
						block.call topic, message
					end
				end
			end
		end

	end

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

		def subscribe
			client.subscribe(self.name) do |topic, message|
				create_feed(feed_params["feed"].merge!({index: self.user.name, type: topic_id, :topic_id => topic_id})) if topic == self.name
			end
		end

		def client
			@client ||= case self.protocol
			when "mqtt"
				MQTT.new(url: url)
			else
				nil
			end
		end


		private

		def faye_subscribe(subscription)
			# topic_id = subscription.topic_id
			client = Faye::Client.new(subscription.host)

			client.subscribe("/#{subscription.name}") do |feed_params|
				
			end
		end

		def create_feed(feed_params)
			feed = Topic::Feed.create(feed_params) 
		end


	end
end
