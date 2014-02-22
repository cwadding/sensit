module RequestHelpers
    def valid_request(h = {})
        {:use_route => :sensit_api, :format => "json"}.merge!(h)
    end

    def valid_session
      {}
    end
end