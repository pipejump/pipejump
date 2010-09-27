module Pipejump
  
  # Class which represents a Deal in the Pipejump API
  #
  # Please consult Pipejump::Resource for more information on how resources work
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