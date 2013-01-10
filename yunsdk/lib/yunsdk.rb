$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'oauth10/kuaipan_oauth'
require 'oauth20/baidu_oauth'
require 'yunsdk/kuaipan'