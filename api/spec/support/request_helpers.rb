module RequestHelpers
    def valid_request(h = {})
      h.merge!({:use_route => :sensit_api, :format => "json", :api_version => 1})        
    end
    
    def valid_session
      {}
    end
end