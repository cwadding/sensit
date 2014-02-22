require_dependency "sensit/api_controller"

module Sensit
  class DataController < ApiController
    include ::DoorkeeperDataAuthorization
    
    respond_to :json, :xml

    # GET topics/1/feeds/1/data/:key
    def show

      if attempting_to_access_topic_from_another_application_without_privilage("read_any_data")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        response = elastic_client.get(index: elastic_index_name, type: elastic_type_name,:id => params[:feed_id], :fields => "#{params[:id]}")
        if response["exists"] || response["found"]
          value = response["fields"][params[:id]]
          render text: value.is_a?(Array) ? value[0] : value
        else
          raise ::Elasticsearch::Transport::Transport::Errors::NotFound
        end
      end
    end

    # PATCH/PUT topics/1/feeds/1/data/1
    def update
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_data")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        if (data_param.blank?)
          head :status => :not_found
        else
          response = elastic_client.update(index: elastic_index_name, type: elastic_type_name,:id => params[:feed_id], :body => {doc: {params[:id] => data_param[:value]}})
          if response.nil?
            head :status => :unprocessable_entity
          else
            head :status => :ok
          end
        end
      end
    end

    private

      def elastic_client
        @client ||= ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new
      end
      # Only allow a trusted parameter "white list" through.
      def data_param
        params.permit(:value)
      end
  end
end
