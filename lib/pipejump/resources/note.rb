module Pipejump
  
  # The Notes resource is represented by an instance of Pipejump::Note.
  # 
  # *Note*: To access any Notes, you need a valid Deal instance, referred to as @deal in the following examples. Notes belong to a deal, so you can only access them via @deal, not the session.
  # 
  # == Access
  # 
  # === Collection
  # 
  # To fetch a collection of Pipejump::Note instances, call
  # 
  # 
  #      @deal.notes 
  #      # => #<Pipejump::Collection resource: Pipejump::Note, owner: #<Pipejump::Deal name: "My Deal", scope: "0", hot: "false", stage_name: "incoming", id: "1", deal_tags: "">>
  # 
  # 
  # This returns a Pipejump::Collection instance. To retrieve an array of Pipejump::Note instances, call the _all_ method on the collection:
  # 
  # 
  #      @deal.notes.all 
  #      # => [#<Pipejump::Note content: "My Note", id: "1">, #<Pipejump::Note content: "Another Note", id: "2">]
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
  #      @deal.notes.first 
  #      # => #<Pipejump::Note content: "My Note", id: "1">
  #      @deal.notes.last 
  #      # => #<Pipejump::Note content: "Another Note", id: "2">
  #      @deal.notes.size
  #      # => 2
  #      @deal.notes.each { |note| puts note.content } 
  #      # Prints out "My Note" and "Another Note"
  #      @deal.notes.collect { |note| note.content } 
  #      # => ["My Note",  "Another Note"]
  #      @deal.notes.reject { |note| note.content == 'My Note' } 
  #      # => ["Another Note"]
  # 
  # 
  # === Resource
  # 
  # To fetch a single resource, call the _find_ method with the resource id as an argument:
  # 
  # 
  #      @deal.notes.find(1) 
  #      # => #<Pipejump::Note content: "My Note", id: "1">
  # 
  # 
  # == Creation
  # 
  # *Note*: Notes require the following fields in the hash of attributes:
  # 
  # * _content_: Note content
  # 
  # To create a new note, call the _create_ method on the Note Pipejump::Collection with a hash of attributes as an argument:
  # 
  # 
  #      @deal.notes.create(:content => 'Third Note') 
  #      # => #<Pipejump::Note content: "Third Note", id: "3">
  # 
  # 
  # If the resource was created properly, it will be returned with a id assigned to it. You can check it by calling the created? method
  # 
  # 
  #      note = @deal.notes.create(:content => 'Third Note') 
  #      # => #<Pipejump::Note content: "Third Note", id: "3">
  #      note.created? 
  #      # => true
  #      note = @deal.notes.create(:content => '') 
  #      # => #<Pipejump::Note content: "">
  #      note.created? 
  #      # => false
  # 
  # 
  # You can access validation/creation errors by calling the _errors_ method on the instance returned by _create_:
  # 
  # 
  #      note = @deal.notes.create(:content => '') 
  #      # => #<Pipejump::Note content: "">
  #      note.created? 
  #      # => false
  #      note.errors 
  #      # => {"note"=>[{"error"=>{"code"=>"E0001", "field"=>"content", "description"=>"Please enter note's message"}}]}
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
  #      note = @deal.notes.create(:content => 'Third Note') 
  #      # => #<Pipejump::Note content: "Third Note", id: "3">
  #      note.content 
  #      # => 'Third Note'
  #      note.content = 'Super Note' 
  #      # => 'Super Note'
  #      note.content 
  #      # => 'Super Note'
  # 
  # 
  # === Saving
  # 
  # Once you've changed the attributes, call the _save_ method on the resource instance:
  # 
  # 
  #      note = @deal.notes.create(:content => 'Third Note') 
  #      # => #<Pipejump::Note content: "Third Note", id: "3">
  #      note.content 
  #      # => 'Third Note'
  #      note.save
  #      # => true
  # 
  # 
  # _save_ returns _true_ if save was successful and _false_ if it failed. In the latter scenario, you can access the errors via the _errors_ method:
  # 
  # 
  #      note = @deal.notes.create(:content => 'Third Note') 
  #      # => #<Pipejump::Note content: "Third Note", id: "3">
  #      note.content = 'Super Note'
  #      # => 'Super Note'
  #      note.save 
  #      # => true
  #      note.content = '' 
  #      # => ''
  #      note.save 
  #      # => false
  #      note.errors 
  #      # => {"note"=>[{"error"=>{"code"=>"E0001", "field"=>"content", "description"=>"Please enter note's message"}}]}
  # 
  # 
  # == Removal
  # 
  # To remove a resource, call the _destroy_ method on the instance:
  # 
  # 
  #      note = @deal.notes.find(1) 
  #      #  => #<Pipejump::Note content: "My Note", id: "1">
  #      note.destroy 
  #      # => true
  # 

  class Note < Resource
  end
  
end