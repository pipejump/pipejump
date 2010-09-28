module Pipejump

  # The Sources resource is represented by an instance of Pipejump::Source.
  # 
  # *Note*: To access any resources, you need a valid Session instance, referred to as @session in the following examples.
  # 
  # == Access
  # 
  # === Collection
  # 
  # To fetch a collection of Pipejump::Source instances, call
  # 
  # 
  #      @session.sources 
  #      # => #<Pipejump::Collection resource: Pipejump::Source>
  # 
  # 
  # This returns a Pipejump::Collection instance. To retrieve an array of Pipejump::Source instances, call the _all_ method on the collection:
  # 
  # 
  #      @session.sources.all 
  #      # => [#<Pipejump::Source name: "My Source", id: "1">, #<Pipejump::Source name: "Another Source", id: "2">]
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
  #      @session.sources.first 
  #      # => #<Pipejump::Source name: "My Source", id: "1">
  #      @session.sources.last 
  #      # => #<Pipejump::Source name: "Another Source", id: "2">
  #      @session.sources.size
  #      # => 2
  #      @session.sources.each { |source| puts source.name } 
  #      # Prints out "My Source" and "Another Source"
  #      @session.sources.collect { |source| source.name } 
  #      # => ["My Source",  "Another Source"]
  #      @session.sources.reject { |source| source.name == 'My Source' } 
  #      # => ["My Source",  "Another Source"]
  # 
  # 
  # === Resource
  # 
  # To fetch a single resource, call the _find_ method with the resource id as an argument:
  # 
  # 
  #      @session.sources.find(1) 
  #      # => #<Pipejump::Source name: "My Source", id: "1">
  # 
  # 
  # == Creation
  # 
  # *Note*: Sources require the following fields in the hash of attributes:
  # 
  # * _name_: a valid name
  # 
  # To create a new source, call the _create_ method on the Source Pipejump::Collection with a hash of attributes as an argument:
  # 
  # 
  #      @session.sources.create(:name => 'Third Source') 
  #      # => #<Pipejump::Source name: "Third Source", id: "3">
  # 
  # 
  # If the resource was created properly, it will be returned with a id assigned to it. You can check it by calling the created? method
  # 
  # 
  #      source = @session.sources.create(:name => 'Third Source') 
  #      # => #<Pipejump::Source name: "Third Source", id: "3">
  #      source.created? 
  #      # => true
  #      source = @session.sources.create(:name => '') 
  #      # => #<Pipejump::Source name: "">
  #      source.created? 
  #      # => false
  # 
  # 
  # You can access validation/creation errors by calling the _errors_ method on the instance returned by _create_:
  # 
  # 
  #      source = @session.sources.create(:name => '') 
  #      # => #<Pipejump::Source name: "">
  #      source.created? 
  #      # => false
  #      source.errors 
  #      # => {"source"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"can't be blank"}}]}
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
  #      source = @session.sources.create(:name => 'Third Source') 
  #      # => #<Pipejump::Source name: "Third Source", id: "3">
  #      source.name 
  #      # => 'Third Source'
  #      source.name = 'Super Source' 
  #      # => 'Super Source'
  #      source.name 
  #      # => 'Super Source'
  # 
  # 
  # === Saving
  # 
  # Once you've changed the attributes, call the _save_ method on the resource instance:
  # 
  # 
  #      source = @session.sources.create(:name => 'Third Source') 
  #      # => #<Pipejump::Source name: "Third Source", id: "3">
  #      source.name 
  #      # => 'Third Source'
  #      source.save
  #      # => true
  # 
  # 
  # _save_ returns _true_ if save was successful and _false_ if it failed. In the latter scenario, you can access the errors via the _errors_ method:
  # 
  # 
  #      source = @session.sources.create(:name => 'Third Source') 
  #      # => #<Pipejump::Source name: "Third Source", id: "3">
  #      source.name = 'Super Source'
  #      # => 'Super Source'
  #      source.save 
  #      # => true
  #      source.name = '' 
  #      # => ''
  #      source.save 
  #      # => false
  #      source.errors 
  #      # => {"source"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"can't be blank"}}]}
  # 
  # 
  # == Removal
  # 
  # To remove a resource, call the _destroy_ method on the instance:
  # 
  # 
  #      source = @session.sources.find(1) 
  #      #  => #<Pipejump::Source name: "My Source", id: "1">
  #      source.destroy 
  #      # => true
  # 
  
  class Source < Resource
  end
  
end