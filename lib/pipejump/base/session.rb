module Pipejump
  
  # Represents an active Session with the Pipejump API
  # 
  # Any access to the Pipejump API requires authorization, which means you need to initialize a Pipejump::Session instance before calling any other methods
  #
  # ==== Authorization
  # To authorize, simply call Pipejump::Session.new with a argument hash with the following keys:
  # * _email_ - your Pipejump user account email
  # * _password_ - your Pipejump user account password
  # * _endpoint_ - (optional) Default is http://api.pipejump.com, however you can override it (for example for development)
  # 
  # You can perform later actions either on a instance returned by the canstructor or within a supplied block
  #   @session = Pipejump::Session.new(:email => EMAIL, :password => PASSWORD)
  #   @session.account
  # or 
  #   Pipejump::Session.new(:email => EMAIL, :password => PASSWORD) do |session|
  #     session.account
  #   end
  # 
  # ==== Account
  # To access the Account instance, call the account method
  #
  # ==== Collections
  # The Session instance provides access to the following Collections:
  # * clients
  # * contacts
  # * deals
  # * sources
  class Session
    
    attr_accessor :token
    
    def initialize(params, &block) 
      if endpoint = params.delete("endpoint") or endpoint = params.delete(:endpoint)
        connection(endpoint)
      end
      authorize(params)
      yield(self) if block_given?
    end
    
    def authorize(params) #:nodoc:
      response = connection.post('/authorization', params.collect { |pair| pair.join('=') }.join('&'))
      data = JSON.parse(response.body)
      self.token = data['authorization']['token']
      raise AuthorizationFailed if response.code == '401'
    end
    
    def connection(endpoint = nil) #:nodoc:
      @connection ||= Connection.new(self, endpoint)
    end
        
    def get(url) #:nodoc:
      response = connection.get(url)
      data = (response.code.to_i == 200 and url.match('.json')) ? JSON.parse(response.body) : ''
      [response.code.to_i, data]
    end

    def post(url, data) #:nodoc:
      response = connection.post(url, data)
      data = url.match('.json') ? JSON.parse(response.body) : response.body
      [response.code.to_i, data]
    end

    def put(url, data) #:nodoc:
      response = connection.put(url, data)
      data = url.match('.json') ? JSON.parse(response.body) : response.body
      [response.code.to_i, data]
    end
    
    def delete(url) #:nodoc:
      response = connection.delete(url)
      [response.code.to_i, response.body]
    end
    
    def inspect
      "#<#{self.class} token: \"#{token}\">"
    end
    
    # Returns a Pipejump::Account instance of the current account
    def account
      code, response = get('/account.json')
      Account.new(response['account'])
    end
    
    # Returns a Pipejump::Collection instance of Clients
    def clients
      Collection.new(self, Client)
    end

    # Returns a Pipejump::Collection instance of Sources
    def sources
      Collection.new(self, Source)
    end

    # Returns a Pipejump::Collection instance of Contacts
    def contacts
      Collection.new(self, Contact)
    end

    # Returns a Pipejump::Collection instance of Deals
    def deals
      Collection.new(self, Deal)
    end

    
  end
end