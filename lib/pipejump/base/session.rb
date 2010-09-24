module Pipejump
  
  class Session
    
    attr_accessor :token
    
    def initialize(params, &block)
      if endpoint = params.delete("endpoint") or endpoint = params.delete(:endpoint)
        connection(endpoint)
      end
      authorize(params)
      yield(self) if block_given?
    end
    
    def authorize(params)
      response = connection.post('/authorization', params.collect { |pair| pair.join('=') }.join('&'))
      data = JSON.parse(response.body)
      self.token = data['authorization']['token']
      raise 'Authorization failed' if response.code == '401'
    end
    
    def connection(endpoint = nil)
      @connection ||= Connection.new(self, endpoint)
    end
    
    def account
      code, response = get('/account.json')
      Account.new(response['account'])
    end
    
    def get(url)
      response = connection.get(url)
      data = (response.code.to_i == 200 and url.match('.json')) ? JSON.parse(response.body) : ''
      [response.code.to_i, data]
    end

    def post(url, data)
      response = connection.post(url, data)
      data = url.match('.json') ? JSON.parse(response.body) : response.body
      [response.code.to_i, data]
    end

    def put(url, data)
      response = connection.put(url, data)
      data = url.match('.json') ? JSON.parse(response.body) : response.body
      [response.code.to_i, data]
    end
    
    def delete(url)
      response = connection.delete(url)
      [response.code.to_i, response.body]
    end
    
    def clients
      Collection.new(self, Client)
    end

    def sources
      Collection.new(self, Source)
    end

    def contacts
      Collection.new(self, Contact)
    end

    def deals
      Collection.new(self, Deal)
    end

    
  end
end