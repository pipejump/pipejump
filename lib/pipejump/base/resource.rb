module Pipejump
  
  class Resource
       
    class << self
      def collection_path(path = nil)
        @collection_path = path if path
        @collection_path || "#{self.to_s.split('::').last.downcase}s"
      end
      
      # Naive implementation of belongs_to association
      def belongs_to(klass)
        class_eval <<-STR
          def #{klass}
            if @attributes['#{klass}'].is_a?(Hash)
              Pipejump::#{klass.to_s.capitalize}.new(@attributes['#{klass}'].merge(:session => @session))
            elsif @attributes['#{klass}_id']
              @session.#{klass}s.find(@attributes[:#{klass}_id])
            end
          end
        STR
      end
      
      # Naive implementation of has_many association
      attr_accessor :has_many_blocks
      def has_many(collection, &block)
        (self.has_many_blocks ||= {})[collection] = block
        class_eval <<-STR
          def #{collection}
            collection = Collection.new(@session, #{collection.to_s[0..-2].capitalize}, self)
            if self.class.has_many_blocks[:#{collection}]
              (class << collection; self; end).class_eval(&self.class.has_many_blocks[:#{collection}])
            end
            collection
          end
        STR
        
      end
      
    end
    
    attr_accessor :attributes
    def initialize(attrs)
      @session = attrs.delete(:session)
      @prefix = attrs.delete(:prefix) || ''
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
      @attributes.collect { |pair| pair[0] = "#{klassname}[#{pair[0]}]"; pair.join('=') }.join('&')
    end
    
    def save
      before_save if respond_to?(:before_save)
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
    
    def element_path
      @prefix + '/' + self.class.collection_path.to_s + '/' + id.to_s
    end
    
    def collection_path
      @prefix + '/' + self.class.collection_path.to_s 
    end
    
    def create
      @session.post(collection_path + '.json', to_query)      
    end

    def update
      @session.put(element_path + '.json', to_query)      
    end
    
    def destroy
      code, data = @session.delete(element_path + '.json')
      code.to_i == 200
    end
    
    def errors
      @errors ||= {}
    end
    
  end
  
end