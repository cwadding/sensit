module RequestHelpers
    def valid_request(h = {})
        {:use_route => :sensit_api, :format => "json", :api_version => "1"}.merge!(h)
    end

    def valid_session(h={})
      {}.merge!(h)
    end


    def refresh_index
        client = ENV['ELASTICSEARCH_URL'] ? ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL']) : ::Elasticsearch::Client.new        
    	client.indices.refresh(index: ELASTIC_INDEX_NAME)
    end

end