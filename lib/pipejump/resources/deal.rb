module Pipejump
  
  class Deal < Resource
    belongs_to :client
    has_many :contacts do
      disable :find, :create, :destroy_all

      def update(ids)  
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
        
    def to_query
      @attributes.collect { |pair| pair[0] = "#{pair[0]}"; pair.join('=') }.join('&')
    end
    
  end
  
end