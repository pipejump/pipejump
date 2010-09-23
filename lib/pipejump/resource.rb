module Pipejump
  
  class Resource
       
    class << self
      def collection_path(path = nil)
        @collection_path = path if path
        @collection_path
      end
    end
    
    attr_accessor :attributes
    def initialize(attrs)
      @session = attrs.delete(:session)
      @attributes = {}
      load(attrs)
    end
    
    def id
      @attributes['id']
    end
    
    def load(attrs = {})
      attrs.each_pair do |key, value|
        @attributes[key.to_s] = value
      end      
    end
    
    def method_missing(meth, *args)
      if meth.to_s[-1].chr == '=' and @attributes[meth.to_s[0..-2]]
        @attributes[meth.to_s[0..-2]] = args.first
      elsif @attributes.has_key?(meth.to_s)
        @attributes[meth.to_s]
      else
        super(meth, args)
      end
    end
    
    def klassname
      self.class.to_s.split('::').last.downcase
    end
    
    def to_query
      query = @attributes.collect { |pair| pair[0] = "#{klassname}[#{pair[0]}]"; pair.join('=') }.join('&')
      query
    end
    
    def save
      @errors = {}
      code, data = id ? update : create # @session.post('/' + self.class.collection_path.to_s + '.json', to_query)
      if data['errors']
        @errors = data['errors']
        false
      else
        load(data[klassname])
        true
      end
    end
    
    def create
      @session.post('/' + self.class.collection_path.to_s + '.json', to_query)      
    end

    def update
      @session.put('/' + self.class.collection_path.to_s + '/' + id.to_s + '.json', to_query)      
    end
    
    def destroy
      code, data = @session.delete('/' + self.class.collection_path.to_s + '/' + id.to_s + '.json')
      code.to_i == 200
    end
    
    def errors
      @errors ||= {}
    end
    
  end
  
end