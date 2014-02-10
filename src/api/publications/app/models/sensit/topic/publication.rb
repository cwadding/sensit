# require 'socket'

module Sensit
	class Topic::Publication < ActiveRecord::Base
		ACTIONS = %w[create update destroy tag]

		belongs_to :topic, class_name: "Sensit::Topic"

		has_many :percolations, dependent: :destroy, foreign_key: "publication_id"
		has_many :rules, through: :percolations

		validates :name, presence: true, uniqueness:  {scope: :user_id}
		validates :host, presence: true
		validates :protocol, presence: true
		validates :port, numericality: { only_integer: true, greater_than: 0, less_than:49152}, allow_nil: true
		has_secure_password :validations => false
		
		scope :with_action, -> { |action| where(:actions_mask & 2**ACTIONS.index(action.to_s) > 0)}
		scope :with_rules, -> { |rule_names| rules.where(:name => rule_names)}

		def actions=(roles)
			self.actions_mask = (actions & ACTIONS).map { |r| 2**ACTIONS.index(r) }.sum
		end

		def actions
			ACTIONS.reject { |r| ((actions_mask || 0) & 2**ACTIONS.index(r)).zero? }
		end


		def publish(message, action)
			name = self.topic_id
			case self.protocol
			when "blower.io"
				message = {to: '+14155550000', message: message}
			when "mail"
				case action
				when "create"
				when "tag"
				when "update"
				end
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
			when "tcp"
				TCP.new(url: uri)
			when "udp"
				UDP.new(url: uri)
			when "http"
				HTTP.new(url: uri)
			when "blower.io"
				HTTP.new(ENV['BLOWERIO_URL'] + '/messages')
			else
				nil
			end
		end		
	end
end
