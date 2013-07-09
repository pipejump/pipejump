require 'uri'
module Pipejump

  class Connection #:nodoc:

    attr_accessor :session, :endpoint

    def initialize(session, endpoint = nil)
      @session = session
      @endpoint = endpoint || 'https://sales.futuresimple.com'
    end

    def site
      parser = URI.const_defined?(:Parser) ? URI::Parser.new : URI
      parser.parse(self.endpoint)
    end

    def post(path, data)
      http.post(session.version_prefix(path), data, headers)
    end

    def put(path, data)
      http.put(session.version_prefix(path), data, headers)
    end

    def get(path)
      http.get(session.version_prefix(path), headers)
    end

    def delete(path)
      http.delete(session.version_prefix(path), headers)
    end

    def headers
      { auth_header => session.token.to_s }
    end

    def auth_header
      if endpoint =~ /leads.futuresimple.com/
        'X-Futuresimple-Token'
      else
        'X-Pipejump-Auth'
      end
    end

    def http
      instance ||= Net::HTTP.new(site.host, site.port)
      if @endpoint.match(/^https:/)
        instance.use_ssl = true
        instance.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      instance
    end

    def inspect
      "#<#{self.class} endpoint: \"#{endpoint}\">"
    end


  end

end
