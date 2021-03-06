#!/usr/bin/env ruby

require 'optparse'
require File.join( File.dirname( __FILE__ ), '..', 'lib', 'postpolicy' )

DEFAULT_CONFIG = File.exists?( '/etc/postpolicy.yml' ) ? '/etc/postpolicy.yml' : 
                      File.join( File.dirname( __FILE__ ), '../postpolicy.yml')

DEFAULT_OPTIONS = { 
  :verbose => false,
  :config => DEFAULT_CONFIG
}

begin
  options = DEFAULT_OPTIONS
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"

    opts.on("-v", "--verbose", "Verbose logging") do |v|
      options[:verbose] = v
    end

    opts.on("-c", "--config", "Path to configuration file") do |c|
      options[:config] = c
    end
  end.parse!

  Logger.info "Starting PostPolicy #{PostPolicy::VERSION::STRING}"
  PostPolicy::Config.load_from_file( options[:config] )
  PostPolicy::Protocol.new.start!
rescue
  Logger.error( $!.message )
  raise $!
end
