module PostPolicy
  module ACL

    class Base

      attr_reader :datasource

      def initialize( datasource )
        @datasource = datasource
      end

      def match?( args )
        :dunno
      end

    end

  end
end
