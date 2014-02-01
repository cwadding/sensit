module Sensit
  class Topic::Feed::Importer
    include ::ActiveModel::Model
        #  extend  ActiveModel::Naming
        # extend  ActiveModel::Translation
        # include ActiveModel::Validations
        # include ActiveModel::Conversion
  extend ::ActiveModel::Callbacks
  include ::ActiveModel::Dirty
    # include Roo
    attr_reader :feeds
    attr_accessor :index
    attr_accessor :type

    def initialize(attributes = {})
      @feeds = []
      super(attributes)
      @errors = ActiveModel::Errors.new(self)
    end

    def feeds=(value)
      if value.is_a?(Array)
          @feeds = value.inject([]) do |arr, body|
            arr << Topic::Feed.new(body.merge!({index: self.index, type: self.type}))
          end
      elsif value.is_a?(ActionDispatch::Http::UploadedFile) || value.is_a?(Rack::Test::UploadedFile)
        @feeds = load_feeds(value)
      else
        raise ::ArgumentError.new("argument must be an Array of feed parameters or a UploadedFile")
      end
    end

    def persisted?
      @feeds.map(&:persisted?).all?
    end

    def save
      unless @feeds.empty?
        if @feeds.map(&:valid?).all?
          response = elastic_client.bulk(index: self.index, type: self.type, body: bulk_body)
          response["items"].map {|item| item.values.first["ok"]}.all? || false
        else
          @feeds.each_with_index do |feed, index|
            feed.errors.full_messages.each do |message|
              self.errors.add :base, "Row #{index+2}: #{message}"
            end
          end
          false
        end
      else
        true
      end
    end

private
    def load_feeds(file)
      feed_arr = []
      spreadsheets = open_spreadsheets(file)
      spreadsheets.each do |spreadsheet|
        header = spreadsheet.shift
        
        spreadsheet.each do |row|
          values = header.inject({}) {|h,field| h.merge!(field => row[header.index(field)])}
          at = row[header.index("at")]
          tz = row[header.index("tz")]
          feed_arr << Topic::Feed.new({index: self.index, type: self.type, at: at, tz: tz, values: values})
        end
      end
      feed_arr.uniq {|feed| feed.at}
    end

    def open_spreadsheets(file)
      case File.extname(file.original_filename)
        when ".csv" then [::Roo::CSV.new(file.path, file_warning: :ignore).to_a]
        when ".xls" then [::Roo::Excel.new(file.path, file_warning: :ignore).to_a]
        when ".xlsx" then [::Roo::Excelx.new(file.path, file_warning: :ignore).to_a]
        when ".ods" then [::Roo::OpenOffice.new(file.path, file_warning: :ignore).to_a]
        when ".zip"
          zf = ::Zip::File.new(file.path)
          spreadsheets = zf.map do |entry|
            # puts entry.name
            zf.get_input_stream(entry) do |stream|
                ::CSV.parse(stream.read) if File.extname(entry.name) == ".csv"
            end
          end
        else raise "Unknown file type: #{file.original_filename}"
      end
    end

    def elastic_client
      @client ||= ::Elasticsearch::Client.new
    end

    def bulk_body
      @feeds.map do |feed|
        feed.new_record? ? { create: {data: feed.to_hash}} : { update: {_id: feed.id, data: {doc: feed.to_hash}}}
      end
    end

  end
end