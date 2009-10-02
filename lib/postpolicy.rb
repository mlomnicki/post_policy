require 'rubygems'
require 'eventmachine'

$:.unshift File.dirname( __FILE__ )

require 'postpolicy/config'
require 'postpolicy/protocol'
require 'postpolicy/access_manager'
require 'postpolicy/logger'
require 'postpolicy/extensions'
require 'postpolicy/server'
require 'postpolicy/rule'
require 'postpolicy/version'

VERBOSE = false unless defined?( VERBOSE )
