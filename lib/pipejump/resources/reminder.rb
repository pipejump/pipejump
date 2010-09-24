module Pipejump
  
  class Reminder < Resource    
    
    def before_save
      if @attributes['date'].is_a?(Time)
        @attributes['date'] = @attributes['date'].strftime('%Y-%m-%d') 
      end
    end
    
  end
  
end