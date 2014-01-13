module RequestHelpers
    def valid_request(h = {})
        {:use_route => :sensit_api, :format => "json", :api_version => 1}.merge!(h)
    end

    def valid_session(h = {})
      {}.merge!(h)
    end
end