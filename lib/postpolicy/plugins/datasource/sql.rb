module PostPolicy
  module DataSource

    class Sql < Base
     
      def initialize( query )
        @query = query
      end

      def exists?( value )
        result = false
        connection do |conn|
          command = conn.create_command( @query )
          reader = command.execute_reader
          while reader.next! 
            if reader.values[0] && reader.values[0] == value
              result = true
              break
            end
          end
        end
        result
      end

      protected
      def connection( &block )
        conn = DataObjects::Connection.new( Config::Db.dbi_params ) 
        block.call( conn )
        conn.close
      end

    end

  end
end
