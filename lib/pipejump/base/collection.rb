module Pipejump
  
  class Collection
    
    def initialize(session, resource_class)
      @session = session
      @resource_class = resource_class
    end
    
    def find(id)
      code, data = @session.get('/' + @resource_class.collection_path.to_s + '/' + id.to_s + '.json')
      key = @resource_class.name.to_s.split('::').last.downcase
      @resource_class.new(data[key].merge(:session =>@session))
    end
    
    def all
      code, data = @session.get('/' + @resource_class.collection_path.to_s + '.json')
      data.collect { |data|
        key = @resource_class.name.to_s.split('::').last.downcase
        @resource_class.new(data[key].merge(:session =>@session))
      }
    end
    
    def create(attrs)
      resource = @resource_class.new(attrs.merge(:session =>@session))
      resource.save
      resource
    end
    
    ['first', 'last'].each do |method|
      class_eval <<-STR
        def #{method}
          all.#{method}
        end
      STR
    end
        
  end
  
end