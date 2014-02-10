require 'uri'

module Sensit
	module Messenger
		class Base
			attr_accessor :host, :port, :username, :password

			attr_reader :protocol
			def initialize(params = {})
				params.each do |attr, value|
					self.public_send("#{attr}=", value)
				end if params
				@protocol = "http"
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
					"#{@protocol}://#{self.username}:#{self.password}@#{self.host}:#{self.port}"
				else
					"#{@protocol}://#{self.host}:#{self.port}"
				end
			end

			def subscribe(name, &block)
				raise NoMethodError.new
			end


			def publish(channel = nil, data)
				raise NoMethodError.new
			end
		end
	end
end