require 'uri'
module Pipejump
  
  class Connection
    
    attr_accessor :session, :endpoint

    def initialize(session, endpoint = 'http://api.pipejump.local')
      @session = session
      @endpoint = endpoint
    end
   
    def request(method, url, data)
      http.send(:method, url, data)
    end
    
    def site
      parser = URI.const_defined?(:Parser) ? URI::Parser.new : URI
      parser.parse(self.endpoint)
    end
    
    def post(path, data)
      http.post(path, data, headers)
    end

    def put(path, data)
      http.put(path, data, headers)
    end

    def get(path)
      http.get(path, headers)
    end

    def delete(path)
      http.delete(path, headers)
    end
    
    def headers
      { 'X-Pipejump-Auth' => session.token.to_s }
    end
    
    def http
      Net::HTTP.new(site.host, site.port)
    end
    
  end

end