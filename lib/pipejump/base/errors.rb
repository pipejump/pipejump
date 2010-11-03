module Pipejump  
  # Error raised when authentication fails
  class AuthenticationFailed < Exception; end
  
  # Error raised when a resource is not found via find
  class ResourceNotFound < Exception; end
  # Error raised when a method is called but is not available for that object
  #
  # Example: Pipejump::Collection of Contact objects within a Deal has the following methods disabled: find, create
  class NotImplemented < Exception; end
end