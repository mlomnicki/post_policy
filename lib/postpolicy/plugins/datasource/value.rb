module PostPolicy
  module DataSource

    class Value < Base
      
      def initialize( values )
        @values = [values].flatten #make it always an array
      end

    end
  end
end
