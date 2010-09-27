module Pipejump
  
  # Class which represents a Reminder in the Pipejump API
  #
  # Please consult Pipejump::Resource for more information on how resources work
  class Reminder < Resource 
    
    def before_save #:nodoc:
      if @attributes['date'].is_a?(Time)
        @attributes['date'] = @attributes['date'].strftime('%Y-%m-%d') 
      end
    end
    
  end
  
end