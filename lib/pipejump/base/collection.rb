module Pipejump
  
  # Represents a collection Resources available in the Pipejump API
  # 
  # ==== Available Collections:
  # * Clients
  #     @session.clients
  # * Contacts
  #     @session.contacts
  # * Sources
  #     @session.sources
  # * Notes in a Deal
  #     @deal.notes
  # * Reminders in a Deal
  #     @deal.reminders
  # * Contacts in a Deal
  #     @deal.contacts
  #   *Please* *note*: This Collection has the following methods disabled: find, create
  #
  # ==== Additional methods:
  # Additionally, each collection allows shorthand calls to the Array returned via all for the following methods:
  # * first
  # * last
  # * each
  # * size
  # * collect
  # * reject
  # ===== Example:
  #   @session.sources.size
  #   @session.sources.each { |source| }
  class Collection
    
    class << self
      # Disable methods specified as arguments
      def disable(*methods) #:nodoc:
        methods.each do |method|
          class_eval <<-STR
            def #{method}; raise NotImplemented; end
          STR
        end
      end
    end

    # Create a new Collection of Resource objects
    # ==== Arguments
    # * _session_ - Session object
    # * _resource_ - class of the Resource for this collection
    # * _owner_ - a Resource object which owns the collection, applies scope to calls
    # ==== Usage
    # Normally you do not call the constructor directly, instead you go via the Session or Deal instance, like this:
    #   @session.clients
    # or
    #   @deal.notes
    # 
    def initialize(session, resource, owner = nil)
      @session = session
      @resource = resource
      @owner = owner
      @prefix = owner ? owner.element_path : ''
    end
        
    # Returns a path to the collection of Resource objects
    def collection_path
      @prefix + '/' + @resource.collection_path.to_s
    end

    # Returns a path to a single Resource
    def element_path(id)
      @prefix + '/' + @resource.collection_path.to_s + '/' + id.to_s
    end
    
    # Returns a single Resource object, based on its _id_
    # ==== Arguments
    # * _id_ - id of Resource 
    def find(id)
      code, data = @session.get(element_path(id) + '.json')
      if code == 200
        key = @resource.name.to_s.split('::').last.downcase
        @resource.new(data[key].merge(:session =>@session))
      elsif code == 404
        raise ResourceNotFound
      end
    end
    
    # Returns an Array of Resource objects
    def all
      code, data = @session.get(collection_path + '.json')
      data.collect { |data|
        key = @resource.name.to_s.split('::').last.downcase
        @resource.new(data[key].merge(:session => @session, :prefix => @prefix))
      }
    end
    
    # Creates and returns a Resource object
    # ==== Arguments
    # * _attrs_ - a Hash of attributes passed to the constructor of the Resource
    def create(attrs)
      resource = @resource.new(attrs.merge(:session => @session, :prefix => @prefix))
      resource.save
      resource
    end
    
    def inspect
      all.inspect
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