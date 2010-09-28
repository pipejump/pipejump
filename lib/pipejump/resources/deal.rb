module Pipejump
  
  # A Deal is represented by an instance of Pipejump::Deal.
  # 
  # *Note*: To access any deals, you need a valid Session instance, referred to as @session in the following examples.
  # 
  # == Access
  # 
  # === Collection
  # 
  # To fetch a collection of Pipejump::Deal instances, call
  # 
  # 
  #      @session.deals 
  #      # => #<Pipejump::Collection resource: Pipejump::Deal>
  # 
  # 
  # This returns a Pipejump::Collection instance. To retrieve an array of Pipejump::Deal instances, call the _all_ method on the collection:
  # 
  # 
  #      @session.deals.all 
  #      # => [#<Pipejump::Deal name: "Good Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "1">, 
  #      #     #<Pipejump::Deal name: "Ok Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "2">]
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
  #      @session.deals.first 
  #      # => #<Pipejump::Deal name: "Good Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "1">
  #      @session.deals.last 
  #      # => #<Pipejump::Deal name: "Ok Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "2">
  #      @session.deals.size
  #      # => 2
  #      @session.deals.each { |deal| puts deal.name } 
  #      # Prints out "Good Deal" and "Ok Deal"
  #      @session.deals.collect { |deal| deal.name } 
  #      # => ["Good Deal",  "Ok Deal"]
  #      @session.deals.reject { |deal| deal.name == 'Good Deal' } 
  #      # => ["Ok Deal"]
  # 
  # 
  # === Resource
  # 
  # To fetch a single deal, call the _find_ method with the deal id as an argument:
  # 
  # 
  #      @session.deals.find(1) 
  #      # => #<Pipejump::Deal name: "Good Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "1">
  # 
  # 
  # == Creation
  # 
  # *Note*: Deals require the following fields in the hash of attributes:
  # 
  # * _name_: a valid name
  # * _client_id_: a valid a Client id 
  # 
  # To create a new deal, call the _create_ method on the Deal Pipejump::Collection with a hash of attributes as an argument. 
  # 
  # 
  #      @session.deals.create(:name => 'Great Deal', :client_id => 1) 
  #      # => #<Pipejump::Deal name: "Great Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "3">
  # 
  # 
  # If the deal was created properly, it will be returned with a id assigned to it. You can check it by calling the created? method
  # 
  # 
  #      deal = @session.deals.create(:name => 'Great Deal', :client_id => 1) 
  #      # => #<Pipejump::Deal name: "Great Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "3">
  #      deal.created? 
  #      # => true
  #      deal = @session.deals.create(:name => '') 
  #      # => #<Pipejump::Deal name: "">
  #      deal.created? 
  #      # => false
  # 
  # 
  # You can access validation/creation errors by calling the _errors_ method on the instance returned by _create_:
  # 
  # 
  #      deal = @session.deals.create(:name => '') 
  #      # => #<Pipejump::Deal name: "">
  #      deal.created? 
  #      # => false
  #      deal.errors 
  #      # => {"deal"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"Please enter a deal name"}}, 
  #      #    {"error"=>{"code"=>"E0001", "field"=>"client", "description"=>"Please enter a valid client id"}}]}
  # 
  # 
  # == Update
  # 
  # To update a deal, change the attributes and call the _save_ method.
  # 
  # === Changing attributes
  # 
  # Each attribute has an accessor which you can use to change the values:
  # 
  # 
  #      deal = @session.deals.create(:name => 'Great Deal', :client_id => 1) 
  #      # => #<Pipejump::Deal name: "Great Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "3">
  #      deal.name 
  #      # => 'Great Deal'
  #      deal.name = 'Super Deal' 
  #      # => 'Super Deal'
  #      deal.name 
  #      # => 'Super Deal'
  # 
  # 
  # === Saving
  # 
  # Once you've changed the attributes, call the _save_ method on the deal instance:
  # 
  # 
  #      deal = @session.deals.create(:name => 'Great Deal', :client_id => 1) 
  #      # => #<Pipejump::Deal name: "Great Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "3">
  #      deal.name = 'Super Deal' 
  #      # => 'Super Deal'
  #      deal.save
  #      # => true
  # 
  # 
  # _save_ returns _true_ if save was successful and _false_ if it failed. In the latter scenario, you can access the errors via the _errors_ method:
  # 
  # 
  #      deal = @session.deals.create(:name => 'Great Deal', :client_id => 1) 
  #      # => #<Pipejump::Deal name: "Great Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "3">
  #      deal.name = 'Super Deal'
  #      # => 'Super Deal'
  #      deal.save 
  #      # => true
  #      deal.name = '' 
  #      # => ''
  #      deal.save 
  #      # => false
  #      deal.errors 
  #      # => {"deal"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"Please enter a deal name"}} ]}
  # 
  # 
  # == Removal
  # 
  # You cannot remove a deal, you can move it between stages
  # 
  # == Changing stages
  # 
  # To change a Deal stage, change the value of the _stage_name_ attribute to one of the following:
  # 
  # * incoming
  # * qualified
  # * quote
  # * closure
  # * won
  # * lost
  # * unqualified 
  # 
  # Afterwards, save the deal to update the Deal stage.
  # 
  # 
  #      deal = @session.deals.create(:name => 'Great Deal', :client_id => 1) 
  #      # => #<Pipejump::Deal name: "Great Deal", scope: "0", hot: "false", stage_name: "incoming", deal_tags: "", id: "3">
  #      deal.stage_name = 'qualified'
  #      # => 'qualified'
  #      deal.save
  #      # => true
  # 
  # 
  # == Contacts
  # 
  # You can access Deal Contacts assigned to a deal by calling _contacts_ on an instance of a Deal:
  # 
  # 
  #      @deal.contacts
  # 
  # 
  # For more information, consult the Deal Contacts page.
  # 
  # == Notes
  # 
  # You can access Notes of a specific deal by calling _notes_ on an instance of a Deal:
  # 
  # 
  #      @deal.notes
  # 
  # 
  # For more information, consult the Notes page.
  # 
  # == Reminders
  # 
  # You can access Reminders of a specific deal by calling _reminders_ on an instance of a Deal:
  # 
  # 
  #      @deal.reminders
  # 
  # 
  # For more information, consult the Reminders page.
  class Deal < Resource 
    belongs_to :client
    has_many :contacts do
      disable :find, :create

      # Updates the Contact resources assigned to a deal
      # 
      # Accepts the following arguments:
      # * String:
      #     @deal.contacts.update('1, 2')
      # * Array of integers:
      #     @deal.contacts.update([1, 2])
      # * Array of Resource objects:
      #     @deal.contacts.update([@contact.id, @contact2.id])
      # * mixed Array of Resource objects and integers:
      #     @deal.contacts.update([1, @contact2])
      def update(ids) #:nodoc:
        if ids.is_a?(Array)
          ids = ids.collect { |element| 
            if element.is_a?(Pipejump::Resource) 
              element.id
            elsif element.is_a?(Fixnum)
              element
            end
          }
          ids = ids.compact.join(',')
        end
        code, data = @session.put(collection_path + '/update', "contact_ids=#{ids}")
        code == 200
      end

    end
    
    has_many :notes
    has_many :reminders
        
    def to_query #:nodoc:
      @attributes.collect { |pair| pair[0] = "#{pair[0]}"; pair.join('=') }.join('&')
    end
    
  end
  
end