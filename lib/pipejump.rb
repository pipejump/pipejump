require 'json'
require 'net/http'
require 'net/https'
module Pipejump #:nodoc: 
end

require 'pipejump/base/collection'
require 'pipejump/base/resource'
require 'pipejump/base/session'
require 'pipejump/base/errors'
require 'pipejump/base/connection'

require 'pipejump/resources/account'
require 'pipejump/resources/deal'
require 'pipejump/resources/note'
require 'pipejump/resources/reminder'
require 'pipejump/resources/source'
require 'pipejump/resources/client'
require 'pipejump/resources/contact'