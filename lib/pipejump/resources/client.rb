module Pipejump
  

  # The Client resource is represented by an instance of Pipejump::Client.
  # 
  # *Note*: To access any resources, you need a valid Session instance, referred to as @session in the following examples.
  # 
  # == Access
  # 
  # === Collection
  # 
  # To fetch a collection of Pipejump::Client instances, call
  # 
  # 
  #      @session.clients 
  #      # => #<Pipejump::Collection resource: Pipejump::Client>
  # 
  # 
  # This returns a Pipejump::Collection instance. To retrieve an array of Pipejump::Client instances, call the _all_ method on the collection:
  # 
  # 
  #      @session.clients.all 
  #      # => [#<Pipejump::Client name: "My Client", id: "1">, #<Pipejump::Client name: "Another Client", id: "2">]
  # 
  # 
  # Instead of _all_, you can also call a variety of Array methods in the collection which will be delegated to the array returned by _all_, such as:
  # 
  # * first
  # * last
  # * each
  # * size
  # * collect
  # * reject
  # 
  # *Examples*:
  # 
  #      @session.clients.first 
  #      # => #<Pipejump::Client name: "My Client", id: "1">
  #      @session.clients.last 
  #      # => #<Pipejump::Client name: "Another Client", id: "2">
  #      @session.clients.size
  #      # => 2
  #      @session.clients.each { |client| puts client.name } 
  #      # Prints out "My Client" and "Another Client"
  #      @session.clients.collect { |client| client.name } 
  #      # => ["My Client",  "Another Client"]
  #      @session.clients.reject { |client| client.name == 'My Client' } 
  #      # => ["My Client",  "Another Client"]
  # 
  # 
  # === Resource
  # 
  # To fetch a single resource, call the _find_ method with the resource id as an argument:
  # 
  # 
  #      @session.clients.find(1) 
  #      # => #<Pipejump::Client name: "My Client", id: "1">
  # 
  # 
  # == Creation
  # 
  # *Note*: Clients require the following fields in the hash of attributes:
  # 
  # * _name_: a valid name
  # 
  # To create a new client, call the _create_ method on the Client Pipejump::Collection with a hash of attributes as an argument:
  # 
  # 
  #      @session.clients.create(:name => 'Third Client') 
  #      # => #<Pipejump::Client name: "Third Client", id: "3">
  # 
  # 
  # If the resource was created properly, it will be returned with a id assigned to it. You can check it by calling the created? method
  # 
  # 
  #      client = @session.clients.create(:name => 'Third Client') 
  #      # => #<Pipejump::Client name: "Third Client", id: "3">
  #      client.created? 
  #      # => true
  #      client = @session.clients.create(:name => '') 
  #      # => #<Pipejump::Client name: "">
  #      client.created? 
  #      # => false
  # 
  # 
  # You can access validation/creation errors by calling the _errors_ method on the instance returned by _create_:
  # 
  # 
  #      client = @session.clients.create(:name => '') 
  #      # => #<Pipejump::Client name: "">
  #      client.created? 
  #      # => false
  #      client.errors 
  #      # => {"client"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"can't be blank"}}]}
  # 
  # 
  # == Update
  # 
  # To update a resource, change the attributes and call the _save_ method.
  # 
  # === Changing attributes
  # 
  # Each attribute has an accessor which you can use to change the values:
  # 
  # 
  #      client = @session.clients.create(:name => 'Third Client') 
  #      # => #<Pipejump::Client name: "Third Client", id: "3">
  #      client.name 
  #      # => 'Third Client'
  #      client.name = 'Super Client' 
  #      # => 'Super Client'
  #      client.name 
  #      # => 'Super Client'
  # 
  # 
  # === Saving
  # 
  # Once you've changed the attributes, call the _save_ method on the resource instance:
  # 
  # 
  #      client = @session.clients.create(:name => 'Third Client') 
  #      # => #<Pipejump::Client name: "Third Client", id: "3">
  #      client.name 
  #      # => 'Third Client'
  #      client.save
  #      # => true
  # 
  # 
  # _save_ returns _true_ if save was successful and _false_ if it failed. In the latter scenario, you can access the errors via the _errors_ method:
  # 
  # 
  #      client = @session.clients.create(:name => 'Third Client') 
  #      # => #<Pipejump::Client name: "Third Client", id: "3">
  #      client.name = 'Super Client'
  #      # => 'Super Client'
  #      client.save 
  #      # => true
  #      client.name = '' 
  #      # => ''
  #      client.save 
  #      # => false
  #      client.errors 
  #      # => {"client"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"can't be blank"}}]}
  # 
  # 
  # == Removal
  # 
  # To remove a resource, call the _destroy_ method on the instance:
  # 
  # 
  #      client = @session.clients.find(1) 
  #      #  => #<Pipejump::Client name: "My Client", id: "1">
  #      client.destroy 
  #      # => true
  # 
  class Client < Resource 
    has_many :contacts do
      disable :create
    end
  end
  
end