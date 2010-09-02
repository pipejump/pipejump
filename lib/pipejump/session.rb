module Pipejump
  
  class Session
    
    attr_accessor :token
    
    def initialize(params, &block)
      authorize(params)
      yield(self) if block_given?
    end
    
    def authorize(params)
      response = connection.post('/authorization', params.collect { |pair| pair.join('=') }.join('&'))
      data = JSON.parse(response.body)
      self.token = data['authorization']['token']
      raise 'Authorization failed' if response.code == '401'
    end
    
    def connection
      @connection ||= Connection.new(self)
    end
    
    def account
      code, response = get('/account.json')
      Account.new(response['account'])
    end
    
    def get(url)
      response = connection.get(url)
      data = JSON.parse(response.body)
      [response.code, data]
    end

    def post(url, data)
      response = connection.post(url, data)
      data = JSON.parse(response.body)
      [response.code, data]
    end

    def put(url, data)
      response = connection.put(url, data)
      data = JSON.parse(response.body)
      [response.code, data]
    end
    
    def delete(url)
      response = connection.delete(url)
      [response.code, response.body]
    end
    
    def clients
      Handler.new(self, Client)
    end

    def sources
      Handler.new(self, Source)
    end
    
  end
end