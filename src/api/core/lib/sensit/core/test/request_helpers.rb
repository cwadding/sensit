module RequestHelpers
    def valid_request(h = {})
        {:use_route => :sensit_api, :format => "json", :api_version => 1}.merge!(h)
    end

    def valid_session(h={})
      {}.merge!(h)
    end


    def refresh_index
        if ENV['ELASTICSEARCH_URL']
          client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
        else
          client = ::Elasticsearch::Client.new
        end        
    	client.indices.refresh(index: ELASTIC_INDEX_NAME)
    end

end