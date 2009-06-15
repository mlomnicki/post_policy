require 'rubygems'
require 'eventmachine'

module PostPolicy

  class AccessManager
  
    include EventMachine::Deferrable

    DEFAULT_ACTION = "DUNNO"

    @@access_list = []

    def self.access_list
      @@access_list   
    end

    def self.<<( action )
      @@access_list << action
    end

    def check( args )
      action = DEFAULT_ACTION
      @@access_list.each do |access|
        if access.match?( args )
          action = access.action
          break
        end
      end
      yield action if block_given?
      return action
    end

  end
end

