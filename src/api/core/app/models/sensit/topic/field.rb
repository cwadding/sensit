module Sensit
  class Topic::Field < ActiveRecord::Base
    extend ::FriendlyId
    friendly_id :key, use: [:slugged, :finders]
  	belongs_to :topic


    ## dynamic validations
    # has_many :data_options
    # data_restrictions
    # max_value
    # min_value
    # inclusion { in: %w(small medium large)}
    # format (regular expression)
    # min_length
    # max_length
    # uniqueness

# float, double, byte, short, integer, and long are supported by elasticsearch
# also suports just date
    DATATYPES = %w[string integer boolean float datetime timezone uri ip_address, lat_long]

    # other datatypes (latitiude, longitude), identifier, credit_card, bank_account, address, city, country, state, province, postal_code, name, enum

  	validates_associated :topic
  	validates :name, presence: true, uniqueness: {scope: :topic_id}
  	validates :key, presence: true, uniqueness: {scope: :topic_id}
    validates :datatype, inclusion: { in: DATATYPES, message: "%{value} is not a valid datatype" } , :allow_nil => true


    # also use the key as part of the decision when deciding the time

    def guess_datatype(value)
      case value.class.to_s
        # does it have a file extension and a url
        # does it have an image file extension
      when "FalseClass", "TrueClass"
        return "boolean"
      when "Date", "Time", "DateTime"
        return "datetime"        
      when "Fixnum", "Float"
        if value > 1328000000
          # Could be a float, integer or a datetime
          time_difference = (value - Time.now.to_f).abs
          if (time_difference < 8.days.to_f || (time_difference < 2.years.to_f && could_be_a_time?)) # is it close to a unix timestamp
            return "datetime"
          else
            return value.class == Fixnum ? "integer" : "float"
          end
        else
          return value.class == Fixnum ? "integer" : "float"
        end
      when "String"
        # does it have a currency symbol
        # does it have a unit
        bool_val = self.class.to_boolean(value)
        return guess_datatype(bool_val) unless bool_val.nil?
        num_val = self.class.to_number(value)
        return guess_datatype(num_val) unless num_val.nil?
            lat_long_val = value.split(',')
            if (lat_long_val.count == 2)
              lat_val = self.class.to_number(value[0])
              long_val = self.class.to_number(value[0])
              return "lat_long" if lat_val.present? && long_val.present? && lat_val >= -90 && lat_val <= 90 && long_val >= -180 && long_val <= 180
            end

            begin
              time_val = Time.parse(value)
              return "datetime"
            rescue ::ArgumentError

            end
            return "timezone" if ActiveSupport::TimeZone.zones_map.keys.include?(value)
            begin
              ip_val = IPAddr.new(value)
              return "ip_address"
            rescue ::IPAddr::InvalidAddressError

            end
            begin
              # image_file video_file file
              uri_val = ::URI.parse(value)
              raise URI::InvalidURIError if uri_val.nil? || uri_val.host.nil?
              return "uri"
            rescue URI::InvalidURIError
              
            end
            return "string"
      else
        nil
      end
    end

# timezone image_file video_file file
    def self.convert(value, type)
      case type
      when "datetime"
        Sensit::Topic::Feed.convert_to_time(value)
      when "integer"
        value.to_i
      when "float"
        value.to_f
      when "string"
        value.to_s
      when "boolean"
        self.to_boolean(value)
      else
        value
      end
    end

    def convert(value)
      self.class.convert(value, self.datatype)
    end

    def could_be_a_time?
      could_be_one_of(["at", "on", "date", "time"])
    end

    def could_be_one_of(list)
      temp_key = key ? key.strip.underscore.split("_").last : nil
      temp_key ? list.include?(temp_key) : true
    end

    ##
    # This method returns the elasticsearch properties based on the datatype for indexing
    def properties
      case self.datatype
      when "timezone" then {type: "string", index: "not_analyzed"}
      when "string" then {type: "string"}
      when "uri" then {type: "string", index: "not_analyzed"}
      when "ip_address" then {type: "ip"}
      when "integer" then {type: "integer"}
      when "boolean" then {type: "boolean"}
      when "float" then {type: "float"}
      when "datetime" then {type: "date", format: "basic_date_time"}
      when "lat_long" then {type: "geo_point", "fielddata" => {format: "compressed",precision: "1cm"}}
      else 
        {}
      end
    end

    private

    def self.to_boolean(value)
      # should I use a regex instead?
      case value.to_s.downcase
      when "no", "false", "n", "f" then false
      when "yes", "true", "y", "t" then true
      else nil
      end
    end

    def self.to_number(value)
      matches = value.match(/\A[+-]?\d+?(\.\d+)?\Z/)
      if matches
        matches[1].nil? ? value.to_i : value.to_f
      else
        nil
      end
    end
    
  end
end
