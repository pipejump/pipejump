module Pipejump
  #
  # Represents a Resource available in the Pipejump API
  #
  # The following Resources are available:
  # * Account via @session.account
  # * Client via @session.clients
  # * Contact via @session.contacts
  # * Deal via @session.deals
  # * Note via @deal.notes
  # * Reminder via @deal.reminders
  # * Source via @deal.sources
  #
  # === Retrieving Resources
  # For information on retrieving resources, please consult the Collection class
  #
  # === Creating a Resource
  # To create a resource, call the create method on the appropriate collection.
  #
  # For example, to create a client, you would do the following:
  #   @client = @session.clients.create(:name => 'Google')
  # This will return an instance of Pipejump::Client
  #
  # You can access the attributes of the instance via the attributes method:
  #   @client.attributes # => { 'id' => 1, 'name' => 'Google' }
  #
  # Pipejump::Resource also provides shortcut accessors for these attributes, similarly to ActiveRecord:
  #   @client.name = 'Yahoo'
  #   @client.name # => 'Yahoo'
  #
  # If the create fails, errors are available via the errors method
  #   @client = @session.clients.create(:name => '')
  #   @client.errors # => {"client"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"Please enter a client name"}}]}
  #
  # For more information on errors, please consult the Pipejump API documentation
  #
  # === Updating a Resource
  # To update a resource, change the desired attributes and call the save method
  #   @client.name = 'Yahoo'
  #   @client.save
  #
  # The save method returns the instance on successful save.
  #
  # If the update fails, save returns false and errors are available via the errors method
  #   @client.name = ''
  #   @client.save # => false
  #   @client.errors # => {"client"=>[{"error"=>{"code"=>"E0001", "field"=>"name", "description"=>"Please enter a client name"}}]}
  #
  # For more information on errors, please consult the Pipejump API documentation
  #
  # === Removing a resource
  # To remove a resource, call the destroy method on the Pipejump::Resource instance
  #   @client.destroy # => true
  #
  class Resource

    class << self
      # Returns the pluralized name of the resource used for the collection
      def collection_path(path = nil)
        @collection_path = path if path
        @collection_path || "#{self.to_s.split('::').last.downcase}s"
      end

      # Naive implementation of belongs_to association
      def belongs_to(klass, options = {}) #:nodoc:
        klass_name = options[:class_name] || klass
        class_eval <<-STR
          def #{klass}
            if @attributes['#{klass}'].is_a?(Hash)
              Pipejump::#{klass_name.to_s.capitalize}.new(@attributes['#{klass}'].merge(:session => @session))
            elsif @attributes['#{klass}_id']
              @session.#{klass_name.to_s.downcase}s.find(@attributes['#{klass}_id'])
            end
          end
        STR
      end

      # Naive implementation of has_many association
      attr_accessor :has_many_blocks #:nodoc:
      def has_many(collection, &block) #:nodoc:
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
    # Constructor for the Resource
    def initialize(attrs)
      @session = attrs.delete(:session)
      @prefix = attrs.delete(:prefix) || ''
      @attributes = {}
      load(attrs)
    end

    def id
      @attributes['id']
    end

    def load(attrs = {}) #:nodoc:
      attrs.each_pair do |key, value|
        @attributes[key.to_s] = value
      end
    end

    def method_missing(meth, *args) #:nodoc:
      if meth.to_s[-1].chr == '=' and @attributes.has_key?(meth.to_s[0..-2])
        @attributes[meth.to_s[0..-2]] = args.first
      elsif @attributes.has_key?(meth.to_s)
        @attributes[meth.to_s]
      else
        super(meth, args)
      end
    end

    def klassname #:nodoc:
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

    def inspect
      "#<#{self.class} #{@attributes.collect { |pair| pair[1] = "\"#{pair[1]}\""; pair.join(': ') }.join(', ')}>"
    end

    def element_path
      @prefix + '/' + self.class.collection_path.to_s + '/' + id.to_s
    end

    def collection_path
      @prefix + '/' + self.class.collection_path.to_s
    end

    def create #:nodoc:
      @session.post(collection_path + '.json', to_query)
    end

    def update #:nodoc:
      @session.put(element_path + '.json', to_query)
    end

    # Destroys the Resource
    def destroy
      code, data = @session.delete(element_path + '.json')
      code.to_i == 200
    end

    # Reloads the resource data from the API
    def reload
      code, data = @session.get(element_path + '.json')
      load(data[klassname])
      self
    end

    # Returns a Hash of errors
    def errors
      @errors ||= {}
    end

    def created?
      !!id
    end

  end

end