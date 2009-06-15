module PostPolicy
  module DataSource

    class Base
     
      def initialize( values = [] )
        @values = values
      end

      def exists?( object )
        @values.include?( object ) 
      end

    end

  end
end
