$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/pipejump'
AUTH = YAML.load_file(File.join(Dir.pwd, 'spec', 'connection.yml'))
