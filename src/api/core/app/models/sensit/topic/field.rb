module Sensit
  class Topic::Field < ActiveRecord::Base
    extend ::FriendlyId
    friendly_id :key, use: [:slugged, :finders]

    before_save :default_datatype
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


    DATATYPES = %w[string integer boolean decimal datetime timezone image_uri video_uri uri document_uri]

  	validates_associated :topic
  	validates :name, presence: true, uniqueness: {scope: :topic_id}
  	validates :key, presence: true, uniqueness: {scope: :topic_id}
    validates :datatype, inclusion: { in: DATATYPES, message: "%{value} is not a valid datatype" }


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
          # Could be a decimal, integer or a datetime
          time_difference = (value - Time.now.to_f).abs
          if (time_difference < 8.days.to_f || (time_difference < 2.years.to_f && could_be_a_time?)) # is it close to a unix timestamp
            return "datetime"
          else
            return value.class == Fixnum ? "integer" : "decimal"
          end
        else
          return value.class == Fixnum ? "integer" : "decimal"
        end
      when "String"
        # does it have a currency symbol
        # does it have a unit
        bool_val = self.class.to_boolean(value)
        return guess_datatype(bool_val) unless bool_val.nil?
        num_val = self.class.to_number(value)
        return guess_datatype(num_val) unless num_val.nil?
            begin
              time_val = Time.parse(value)
              return "datetime"
            rescue ::ArgumentError

            end
            return "timezone" if ActiveSupport::TimeZone.zones_map.keys.include?(value)
            begin
              # image_file video_file file
              uri_val = ::URI.parse(value)
              raise URI::InvalidURIError if uri_val.nil? || uri_val.host.nil?
              return guess_datatype(uri_val)
            rescue URI::InvalidURIError
              
            end
            return "string"
      else
        if (value.is_a?(URI))
          ext = File.extname(value.path).downcase
          return "image_uri" if [".jpg", ".gif", ".png", ".webp"].include?(ext) || (ext.blank? && could_be_an_image?)
          return "video_uri" if [".avi", ".mp4", ".mov", ".mpg", ".ogv", ".webm"].include?(ext) || (ext.blank? && could_be_a_video?)
          return "document_uri" if [".pdf", ".doc", ".docx"].include?(ext)
          return "uri"
        else
          nil
        end
      end
    end

# timezone image_file video_file file
    def self.convert(value, type)
      case type
      when "datetime"
        Sensit::Topic::Feed.convert_to_time(value)
      when "integer"
        value.to_i
      when "decimal"
        value.to_f
      when "string"
        value.to_s
      when "boolean"
        self.to_boolean(value)
      else
        value
      end
    end

    def self.convert(value)
      self.class.convert(value, self.datatype)
    end    

    def could_be_a_video?
      could_be_one_of(["video"])
    end

    def could_be_an_image?
      could_be_one_of(["image"])
    end

    def could_be_a_time?
      could_be_one_of(["at", "on", "date", "time"])
    end

    def could_be_one_of(list)
      temp_key = key ? key.strip.underscore.split("_").last : nil
      temp_key ? list.include?(temp_key) : true
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

    def default_datatype
      self.datatype ||= "string"
    end
    
  end
end
