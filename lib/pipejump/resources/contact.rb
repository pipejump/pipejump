module Pipejump
  
  # A Contact is represented by an instance of Pipejump::Contact.
  # 
  # *Note*: To access any contacts, you need a valid Session instance, referred to as @session in the following examples.
  # 
  # == Access
  # 
  # === Collection
  # 
  # To fetch a collection of Pipejump::Contact instances, call
  # 
  # 
  #      @session.contacts 
  #      # => #<Pipejump::Collection recontact: Pipejump::Contact>
  # 
  # 
  # This returns a Pipejump::Collection instance. To retrieve an array of Pipejump::Contact instances, call the _all_ method on the collection:
  # 
  # 
  #      @session.contacts.all 
  #      # => [#<Pipejump::Contact name: "Tom", id: "1", mobile: "123", phone: "456", email: "tom@email.com">, #<Pipejump::Contact name: "Mike", id: "2", mobile: "321", phone: "654", email: "mike@email.com">]
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
  #      @session.contacts.first 
  #      # => #<Pipejump::Contact name: "Tom", id: "1", mobile: "123", phone: "456", email: "tom@email.com">
  #      @session.contacts.last 
  #      # => #<Pipejump::Contact name: "Mike", id: "2", mobile: "321", phone: "654", email: "mike@email.com">
  #      @session.contacts.size
  #      # => 2
  #      @session.contacts.each { |contact| puts contact.name } 
  #      # Prints out "Tom" and "Mike"
  #      @session.contacts.collect { |contact| contact.name } 
  #      # => ["Tom",  "Mike"]
  #      @session.contacts.reject { |contact| contact.name == 'Tom' } 
  #      # => ["Mike"]
  # 
  # 
  # === Resource
  # 
  # To fetch a single contact, call the _find_ method with the contact id as an argument:
  # 
  # 
  #      @session.contacts.find(1) 
  #      # => #<Pipejump::Contact name: "Tom", id: "1", mobile: "123", phone: "456", email: "tom@email.com">
  # 
  # 
  # == Creation
  # 
  # *Note*: Contacts require the following fields in the hash of attributes:
  # 
  # * _name_: a valid name
  # * _client_id_: a valid a Client| id 
  # 
  # To create a new contact, call the _create_ method on the Contact Pipejump::Collection with a hash of attributes as an argument. 
  # 
  # 
  #      @session.contacts.create(:name => 'Jerry', :client_id => 1) 
  #      # => #<Pipejump::Contact name: "Jerry", id: "3", mobile: "", client_id: "1", phone: "", email: "">
  # 
  # 
  # If the contact was created properly, it will be returned with a id assigned to it. You can check it by calling the created? method
  # 
  # 
  #      contact = @session.contacts.create(:name => 'Jerry', :client_id => 1) 
  #      # => #<Pipejump::Contact name: "Jerry", id: "3", mobile: "", client_id: "1", phone: "", email: "">
  #      contact.created? 
  #      # => true
  #      contact = @session.contacts.create(:name => '') 
  #      # => #<Pipejump::Contact name: "">
  #      contact.created? 
  #      # => false
  # 
  # 
  # You can access validation/creation errors by calling the _errors_ method on the instance returned by _create_:
  # 
  # 
  #      contact = @session.contacts.create(:name => '') 
  #      # => #<Pipejump::Contact name: "">
  #      contact.created? 
  #      # => false
  #      contact.errors 
  #      # => "contact"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"Well... we need a name."}}, {"error"=>{"code"=>"E0001", "field"=>"client", "description"=>"can't be blank"}}]}
  # 
  # 
  # == Update
  # 
  # To update a contact, change the attributes and call the _save_ method.
  # 
  # === Changing attributes
  # 
  # Each attribute has an accessor which you can use to change the values:
  # 
  # 
  #      contact = @session.contacts.create(:name => 'Jerry', :client_id => 1) 
  #      # => #<Pipejump::Contact name: "Jerry", id: "3", mobile: "", client_id: "1", phone: "", email: "">
  #      contact.name 
  #      # => 'Jerry'
  #      contact.name = 'Wally' 
  #      # => 'Wally'
  #      contact.name 
  #      # => 'Wally'
  # 
  # 
  # === Saving
  # 
  # Once you've changed the attributes, call the _save_ method on the contact instance:
  # 
  # 
  #      contact = @session.contacts.create(:name => 'Jerry', :client_id => 1) 
  #      # => #<Pipejump::Contact name: "Jerry", id: "3", mobile: "", client_id: "1", phone: "", email: "">
  #      contact.name = 'Wally' 
  #      # => 'Wally'
  #      contact.save
  #      # => true
  # 
  # 
  # _save_ returns _true_ if save was successful and _false_ if it failed. In the latter scenario, you can access the errors via the _errors_ method:
  # 
  # 
  #      contact = @session.contacts.create(:name => 'Jerry', :client_id => 1) 
  #      # => #<Pipejump::Contact name: "Jerry", id: "3", mobile: "", client_id: "1", phone: "", email: "">
  #      contact.name = 'Wally'
  #      # => 'Wally'
  #      contact.save 
  #      # => true
  #      contact.name = '' 
  #      # => ''
  #      contact.save 
  #      # => false
  #      contact.errors 
  #      # => "contact"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"Well... we need a name."}}, {"error"=>{"code"=>"E0001", "field"=>"client", "description"=>"can't be blank"}}]}
  # 
  # 
  # == Removal
  # 
  # To remove a contact, call the _destroy_ method on the instance:
  # 
  # 
  #      contact = @session.contacts.find(1) 
  #      #  => #<Pipejump::Contact name: "Tom", id: "1", mobile: "123", phone: "456", email: "tom@email.com">
  #      contact.destroy 
  #      # => true
  # 
  #
  # = Contacts within a Deal
  # 
  # A Contact is represented by an instance of Pipejump::Contact. Deal Contacts, however, can only be accessed from a specific deal.
  #
  # *Note*: To access any Deal Contacts, you need a valid Deal| instance, referred to as @deal in the following examples. Deal Contacts belong to a deal, so you can only access them via @deal, not the session.
  # 
  # == Access
  # 
  # === Collection
  # 
  # To fetch a collection of Pipejump::Contact instances belonging to a specific Deal, call
  # 
  # 
  #      @deal.contacts 
  #      # => #<Pipejump::Collection resource: Pipejump::Contact, owner: #<Pipejump::Deal name: "My Deal", scope: "0", hot: "false", stage_name: "incoming", id: "1", deal_tags: "">>
  # 
  # 
  # This returns a Pipejump::Collection instance. To retrieve an array of Pipejump::Contact instances belonging to a specific Deal, call the _all_ method on the collection:
  # 
  # 
  #      @deal.contacts.all 
  #      # => [#<Pipejump::Contact name: "Tom", id: "1", mobile: "123", phone: "456", email: "tom@email.com">, 
  #      #     #<Pipejump::Contact name: "Mike", id: "2", mobile: "321", phone: "654", email: "mike@email.com">]
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
  #      @deal.contacts.first 
  #      # => #<Pipejump::Contact name: "Tom", id: "1", mobile: "123", phone: "456", email: "tom@email.com">
  #      @deal.contacts.last 
  #      # => #<Pipejump::Contact name: "Mike", id: "2", mobile: "321", phone: "654", email: "mike@email.com">
  #      @deal.contacts.size
  #      # => 2
  #      @deal.contacts.each { |contact| puts contact.name } 
  #      # Prints out "Tom" and "Mike"
  #      @deal.contacts.collect { |contact| contact.name } 
  #      # => ["Tom",  "Mike"]
  #      @deal.contacts.reject { |contact| contact.name == 'Tom' } 
  #      # => ["Mike"]
  # 
  # 
  # == Updating
  # 
  # To update the Contacts that are assigned to a Deal|, call the _update_ method on the Contacts collection:
  # 
  # 
  #      @deal.contacts.collect(&:id)
  #      # => ['1', '2', '3']
  #      @deal.contacts.update('1,2')
  #      # => true
  #      @deal.contacts.collect(&:id)
  #      # => ['1', '2']
  # 
  # 
  # *Note*: The Contacts must have the same Client as the Deal or update will return _false_
  class Contact < Resource
    belongs_to :client
  end
  
end