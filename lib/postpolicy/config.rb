require 'yaml'
require 'singleton'

Dir.glob( File.join( File.dirname( __FILE__ ), "plugins/base/*" ) ).each { |base| require base }
Dir.glob( File.join( File.dirname( __FILE__ ), "plugins/acl/*" ) ).each { |acl| require acl }
Dir.glob( File.join( File.dirname( __FILE__ ), "plugins/datasource/*" ) ).each { |datasource| require datasource }

module PostPolicy

  class Config

    def self.load_from_file( filename )
      load( YAML.load_file( filename ) )
    end

    def self.load( config_hash ) 
      acls = Hash.new { |hsh, key| hsh[key] = Array.new }
      config_acls = config_hash.delete( "acl" )
      config_acls.each_pair do |human_name, klass_value_maps|
        klass_value_maps.each_pair do |klass, value|
          acls[human_name] << ACL.const_get(klass.classify).new( resolve_datasource( value ) )
        end
      end
      actions = config_hash.delete( "action" )
      accesses = config_hash.delete( "access" )
      accesses.each_pair do |action, acl|
        AccessManager << Access.new( acls[acl], actions[action] )
      end
      Db.load( config_hash["database"] )
    end

    class Db
      class << self
        attr_reader :dbconfig, :dbi_params

        def load( filename )
          if filename 
            @dbconfig = YAML.load_file( filename ).stringify_keys!.freeze
            require "do_#{@dbconfig[:driver]}"
            @dbi_params = "#{@dbconfig[:driver]}://#{@dbconfig[:user]}:#{@dbconfig[:password]}@#{@dbconfig[:host]}:#{@dbconfig[:port]}/#{@dbconfig[:database]}"
          end
        end

      end
    end

    protected

    def self.resolve_datasource( klass_and_value )
      @@datasource_cache ||= {}
      klass, value = klass_and_value.split( "://" )
      if value == nil # consider as constant value
        value = klass
        klass = "value"
      end
      @@datasource_cache[klass] ||= DataSource.const_get(klass.classify)

      return @@datasource_cache[klass].new( value )
    end

  end

end

