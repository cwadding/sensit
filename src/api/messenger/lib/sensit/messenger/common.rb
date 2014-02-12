
module Sensit
  module Messenger

    @@schemes = {}
    def self.scheme_list
      @@schemes
    end

    def self.parse(uri)
      obj = URI(uri)
      if obj && obj.scheme && scheme_list.keys.include?(obj.scheme.upcase)
        scheme_list[obj.scheme.upcase].new(:host => obj.host, :port => obj.port, :username => obj.user, :password => obj.password, :path => obj.path, :query => obj.query)
      else
        nil
      end       
    end
  end
end