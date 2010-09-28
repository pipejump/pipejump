module Pipejump
  
  # The Account resource is represented by an instance of Pipejump::Account, which holds information about your account, such as:
  # 
  # * id
  # * name
  # * currency
  # 
  # *Note*: To access any resources, you need a valid [[Session]] instance, referred to as @session in the following examples.
  # 
  # == Access
  # 
  # To access an instance of Pipejump::Account, call 
  # 
  #   @session.account
  # 
  class Account < Resource 
  end
  
end