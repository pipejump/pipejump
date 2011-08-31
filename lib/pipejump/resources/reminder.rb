module Pipejump

  # The Reminders resource is represented by an instance of Pipejump::Reminder.
  #
  # *Reminder*: To access any Reminders, you need a valid Deal instance, referred to as @deal in the following examples. Reminders belong to a deal, so you can only access them via @deal, not the session.
  #
  # == Access
  #
  # === Collection
  #
  # To fetch a collection of Pipejump::Reminder instances, call
  #
  #
  #      @deal.reminders
  #      # => #<Pipejump::Collection resource: Pipejump::Reminder, owner: #<Pipejump::Deal name: "My Deal", scope: "0", hot: "false", stage_name: "incoming", id: "1", deal_tags: "">>
  #
  #
  # This returns a Pipejump::Collection instance. To retrieve an array of Pipejump::Reminder instances, call the _all_ method on the collection:
  #
  #
  #      @deal.reminders.all
  #      # => [#<Pipejump::Reminder done: "false", time: "14:00", id: "1", date: "2010-11-11", content: "My Reminder">,
  #      #     #<Pipejump::Reminder done: "false", time: "16:00", id: "2", date: "2010-11-11", content: "Another Reminder">]
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
  #      @deal.reminders.first
  #      # => #<Pipejump::Reminder done: "false", time: "14:00", id: "1", date: "2010-11-11", content: "My Reminder">
  #      @deal.reminders.last
  #      # => #<Pipejump::Reminder done: "false", time: "16:00", id: "2", date: "2010-11-11", content: "Another Reminder">
  #      @deal.reminders.size
  #      # => 2
  #      @deal.reminders.each { |reminder| puts reminder.content }
  #      # Prints out "My Reminder" and "Another Reminder"
  #      @deal.reminders.collect { |reminder| reminder.content }
  #      # => ["My Reminder",  "Another Reminder"]
  #      @deal.reminders.reject { |reminder| reminder.content == 'My Reminder' }
  #      # => ["Another Reminder"]
  #
  #
  # === Resource
  #
  # To fetch a single resource, call the _find_ method with the resource id as an argument:
  #
  #
  #      @deal.reminders.find(1)
  #      # => #<Pipejump::Reminder done: "false", time: "14:00", id: "1", date: "2010-11-11", content: "My Reminder">
  #
  #
  # == Creation
  #
  # *Reminder*: Reminders require the following fields in the hash of attributes:
  #
  # * _content_: Reminder content
  # * _date_: Date for the Reminder (ex. 2010-11-11)
  # * _time_: Time for the Reminder (ex. 14:00)
  #
  # To create a new reminder, call the _create_ method on the Reminder Pipejump::Collection with a hash of attributes as an argument:
  #
  #
  #      @deal.reminders.create(:content => 'Third Reminder', :date => '2010-11-11', :time => '19:00'})
  #      # => #<Pipejump::Reminder done: "false", time: "19:00", id: "3", date: "2010-11-11", content: "Third Reminder">
  #
  #
  # If the resource was created properly, it will be returned with a id assigned to it. You can check it by calling the created? method
  #
  #
  #      reminder = @deal.reminders.create(:content => 'Third Reminder', :date => '2010-11-11', :time => '19:00'})
  #      # => #<Pipejump::Reminder done: "false", time: "19:00", id: "3", date: "2010-11-11", content: "Third Reminder">
  #      reminder.created?
  #      # => true
  #      reminder = @deal.reminders.create(:content => '')
  #      # => #<Pipejump::Reminder content: "">
  #      reminder.created?
  #      # => false
  #
  #
  # You can access validation/creation errors by calling the _errors_ method on the instance returned by _create_:
  #
  #
  #      reminder = @deal.reminders.create(:content => '')
  #      # => #<Pipejump::Reminder content: "">
  #      reminder.created?
  #      # => false
  #      reminder.errors
  #      # => {"reminder"=>[{"error"=>{"code"=>"E0000", "field"=>"time", "description"=>"The time and date must be in the future"}},
  #      #    {"error"=>{"code"=>"E0001", "field"=>"date", "description"=>"The time and date must be in the future"}},
  #      #    {"error"=>{"code"=>"E0001", "field"=>"content", "description"=>"can't be blank"}}]}
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
  #      reminder = @deal.reminders.create(:content => 'Third Reminder', :date => '2010-11-11', :time => '19:00'})
  #      # => #<Pipejump::Reminder done: "false", time: "19:00", id: "3", date: "2010-11-11", content: "Third Reminder">
  #      reminder.content
  #      # => 'Third Reminder'
  #      reminder.content = 'Super Reminder'
  #      # => 'Super Reminder'
  #      reminder.content
  #      # => 'Super Reminder'
  #
  #
  # === Saving
  #
  # Once you've changed the attributes, call the _save_ method on the resource instance:
  #
  #
  #      reminder = @deal.reminders.create(:content => 'Third Reminder', :date => '2010-11-11', :time => '19:00'})
  #      # => #<Pipejump::Reminder done: "false", time: "19:00", id: "3", date: "2010-11-11", content: "Third Reminder">
  #      reminder.content
  #      # => 'Third Reminder'
  #      reminder.save
  #      # => true
  #
  #
  # _save_ returns _true_ if save was successful and _false_ if it failed. In the latter scenario, you can access the errors via the _errors_ method:
  #
  #
  #      reminder = @deal.reminders.create(:content => 'Third Reminder', :date => '2010-11-11', :time => '19:00'})
  #      # => #<Pipejump::Reminder done: "false", time: "19:00", id: "3", date: "2010-11-11", content: "Third Reminder">
  #      reminder.content = 'Super Reminder'
  #      # => 'Super Reminder'
  #      reminder.save
  #      # => true
  #      reminder.content = ''
  #      # => ''
  #      reminder.save
  #      # => false
  #      reminder.errors
  #      # => {"reminder"=>[{"error"=>{"code"=>"E0001", "field"=>"content", "description"=>"can't be blank"}}]}
  #
  #
  # == Removal
  #
  # To remove a resource, call the _destroy_ method on the instance:
  #
  #
  #      reminder = @deal.reminders.find(1)
  #      #  => #<Pipejump::Reminder content: "My Reminder", id: "1">
  #      reminder.destroy
  #      # => true
  #

  class Reminder < Resource

    def before_save #:nodoc:
      # Make sure this attribute is not sent
      @attributes.delete('send_time_display')
      @attributes.delete('related_to')
      if @attributes['date'].is_a?(Time)
        @attributes['date'] = @attributes['date'].strftime('%Y-%m-%d')
      end
    end

  end

end