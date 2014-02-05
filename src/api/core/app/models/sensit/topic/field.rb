module Sensit
  class Topic::Field < ActiveRecord::Base
    extend ::FriendlyId
    friendly_id :key, use: [:slugged, :finders]

    after_initialize :default_datatype
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


    DATATYPES = %w[string integer boolean decimal datetime timezone image_file video_file file]

  	validates_associated :topic
  	validates :name, presence: true, uniqueness: {scope: :topic_id}
  	validates :key, presence: true, uniqueness: {scope: :topic_id}
    validates :datatype, inclusion: { in: DATATYPES, message: "%{value} is not a valid datatype" }


    def self.guess_datatype(value)
      case value.class
      when Boolean
        # is it 
      when Fixnum
        # is it close to a unix timestamp
      when String
        # is it the string 'true' or 'false' / 'T' or 'F' / '1' or '0'
        # is it in the format of a datetime
        # is it included in the timezones
        # does it have a file extension and a url
          # does it have an image file extension
        # does it
      else

      end
    end

  	def convert(value)
      self.class.convert(value, datatype)
    end

    def self.convert(value, type)
      case type
      when "datetime"
        Sensit::Feed.convert_to_time(value)
      when "integer"
        value.to_i
      when "decimal"
        value.to_f
      else
        value
      end
    end

    private

    def default_datatype
      self.datatype ||= "string"
    end
    
  end
end