$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/pipejump'
require 'yaml'
AUTH = YAML.load_file(File.join(Dir.pwd, 'spec', 'connection.yml'))

class PipejumpSpec
  class << self
    attr_accessor :session
  end
end
PipejumpSpec.session = Pipejump::Session.new(AUTH.dup)

def uuid
  Time.now.to_i.to_s + 'x' + rand(100000000).to_s + 'X' + rand(100000000).to_s
end