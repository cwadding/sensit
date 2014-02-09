# require 'socket'

module Sensit

	class PubSubCiient
		attr_accessor :host, :port, :username, :password

		def initialize(params = {})
			params.each do |attr, value|
				self.public_send("#{attr}=", value)
			end if params
			super()
		end

		def uri=(value)
			url = ::URI.parse value
			self.host = url.host
			self.port = url.port
			self.username = url.user
			self.password = url.password
		end

		def uri
			if (self.username)
				"mqtt://#{self.username}:#{self.password}@#{self.host}:#{self.port}"
			else
				"mqtt://#{self.host}:#{self.port}"
			end
		end

		def subscribe(name, &block)
			raise NoMethodError.new
		end


		def publish(channel = nil, data)
			raise NoMethodError.new
		end
	end

	class TCP < PubSubCiient

		def subscribe(name, &block)
			s = TCPSocket.new self.host, self.port
			# ::Thread.new do
				while line = s.gets # Read lines from socket
					puts line         # and print them
				end
			# end
			s.close
		end

		def publish(channel = nil, data)
			server = TCPServer.new self.host, self.port
			loop do
				Thread.start(server.accept) do |client|
					client.puts "Hello !"
					client.puts "Time is #{Time.now}"
					client.close
				end
			end
		end
	end

	class UDP < PubSubCiient

		def subscribe(name, &block)
			s = UDPSocket.new
			s.bind(self.host, self.port)
			s.recvfrom(10)
		end

		def publish(channel = nil, data)
			s = UDPSocket.new
			s.bind(self.host, self.port)
			s.send(data, "0", self.host, self.port)
		end
	end	

	class HTTP < PubSubCiient

		def publish(channel = nil, data)
			url = URI(uri)
			req = Net::HTTP::Post.new(url)
			req.set_form_data(data)
			req.basic_auth self.username, self.password if self.username

			res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => url.scheme == 'https') do |http|
			  http.request(req)
			end

			case res
			when Net::HTTPSuccess, Net::HTTPRedirection
			  # OK
			else
			  res.value
			end
		end
	end


	class Topic::Publication < ActiveRecord::Base
		ACTIONS = %w[create update destroy tag]

		belongs_to :topic, class_name: "Sensit::Topic"

		
		# has_many :percolators need a list of percolators but registered percolators need in a database table

		scope :with_action, -> { |action| where(:actions_mask & 2**ACTIONS.index(action.to_s) > 0)}

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
