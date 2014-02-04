require_dependency "sensit/api_controller"

module Sensit
  class DataController < ApiController
    include ::DoorkeeperDataAuthorization
    
    respond_to :json, :xml

    # GET topics/1/feeds/1/data/:key
    def show
      # :fields => [:key]
      feed = Topic::Feed.find({index: elastic_index_name, type: elastic_type_name, id:  params[:feed_id].to_s})
      render text: feed.values[params[:id]]
    end

    # PATCH/PUT topics/1/feeds/1/data/1
    def update
      if (data_param.nil?)
        head :status => :not_found
      else
        response = elastic_client.update(index: elastic_index_name, type: elastic_type_name,:id => params[:feed_id], :body => {doc: {params[:id] => data_param}})
        if response["ok"]
          head :status => :ok
        else
          head :status => :unprocessable_entity
        end
      end
    end

    private

      def elastic_client
        if ENV['ELASTICSEARCH_URL']
          @client ||= ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
        else
          @client ||= ::Elasticsearch::Client.new
        end
      end
      # Only allow a trusted parameter "white list" through.
      def data_param
        params.permit(fields)
      end
  end
end
