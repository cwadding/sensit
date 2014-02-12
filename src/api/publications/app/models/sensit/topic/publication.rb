# require 'socket'

module Sensit
	class Topic::Publication < ActiveRecord::Base
		ACTIONS = %w[create update destroy tag]

		belongs_to :topic, class_name: "Sensit::Topic"

		has_many :percolations, dependent: :destroy, foreign_key: "publication_id"
		has_many :rules, through: :percolations

		validates :host, presence: true
		validates :protocol, presence: true
		validates :port, numericality: { only_integer: true, greater_than: 0, less_than:49152}, allow_nil: true
		has_secure_password :validations => false
		
		scope :with_action, lambda{ |action| where("actions_mask & ? > 0 ", 2**ACTIONS.index(action.to_s))}
		scope :with_percolations, lambda{ |rule_names| joins(:rules).where("sensit_rules" => {:name => rule_names}).select("DISTINCT sensit_topic_publications.*")}

		def actions=(actions_array)
			self.actions_mask = (actions_array & ACTIONS).map { |r| 2**ACTIONS.index(r) }.sum
		end

		def actions
			ACTIONS.reject { |r| ((actions_mask || 0) & 2**ACTIONS.index(r)).zero? }
		end


		def publish(message, action=nil)
			name = self.topic_id
			case self.protocol
			when "blower.io"
				message = {to: '+14155550000', message: message}
			else
				nil
			end			
			client.publish(name, message)
		end

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
				"#{protocol}://#{self.username}:#{self.password}@#{self.host}:#{self.port}"
			else
				"#{protocol}://#{self.host}:#{self.port}"
			end
		end

		def client
			@client ||= case self.protocol
			when "tcp", "udp", "http", "mqtt"
				Messenger.parse(uri: uri)				
			when "blower.io"
				Messenger::HTTP.new(uri: (ENV['BLOWERIO_URL'] || "http://localhost") + '/messages')
			else
				nil
			end
		end		
	end
end
