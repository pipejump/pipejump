module Pipejump
  
  class Collection
    
    class << self
      # Specific function, used to disable methods in a metaclass
      def disable(*methods)
        methods.each do |method|
          class_eval <<-STR
            def #{method}; raise NotImplemented; end
          STR
        end
      end
    end
        
    def initialize(session, resource_class, owner = nil)
      @session = session
      @resource_class = resource_class
      @prefix = owner ? owner.element_path : ''
    end
    
    def collection_path
      @prefix + '/' + @resource_class.collection_path.to_s 
    end

    def element_path(id)
      @prefix + '/' + @resource_class.collection_path.to_s + '/' + id.to_s 
    end
    
    def find(id)
      code, data = @session.get(element_path(id) + '.json')
      if code == 200
        key = @resource_class.name.to_s.split('::').last.downcase
        @resource_class.new(data[key].merge(:session =>@session))
      elsif code == 404
        raise ResourceNotFound
      end
    end
    
    def all
      code, data = @session.get(collection_path + '.json')
      data.collect { |data|
        key = @resource_class.name.to_s.split('::').last.downcase
        @resource_class.new(data[key].merge(:session => @session, :prefix => @prefix))
      }
    end
    
    def create(attrs)
      resource = @resource_class.new(attrs.merge(:session => @session, :prefix => @prefix))
      resource.save
      resource
    end
    
    ['first', 'last', 'each', 'size', 'collect', 'reject'].each do |method|
      class_eval <<-STR
        def #{method}(*args, &block)
          all.#{method}(*args, &block)
        end
      STR
    end
        
  end
  
end