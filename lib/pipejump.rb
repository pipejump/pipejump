require 'json'
module Pipejump
end

require File.dirname(__FILE__) + '/pipejump/base/collection'
require File.dirname(__FILE__) + '/pipejump/base/resource'
require File.dirname(__FILE__) + '/pipejump/base/session'
require File.dirname(__FILE__) + '/pipejump/base/connection'

require File.dirname(__FILE__) + '/pipejump/resources/account'
require File.dirname(__FILE__) + '/pipejump/resources/deal'
require File.dirname(__FILE__) + '/pipejump/resources/source'
require File.dirname(__FILE__) + '/pipejump/resources/client'
require File.dirname(__FILE__) + '/pipejump/resources/contact'