require 'uri'

module Sensit
	module Messenger

		class Base
			attr_accessor :host, :port, :username, :password, :path, :query

			attr_reader :protocol
			def initialize(params = {})
				@protocol = "http"
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
				self.path = url.path
				self.query = url.query
			end

			def uri
				if (self.username)
					"#{@protocol}://#{self.username}:#{self.password}@#{self.host}:#{self.port}"
				else
					"#{@protocol}://#{self.host}:#{self.port}#{self.path}?#{self.query}"
				end
			end
		end
	end
end