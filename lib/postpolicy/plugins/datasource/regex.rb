module PostPolicy
  module DataSource

    class Regex < Base

      def initialize( regex )
        @regex = regex
      end

      def exists?( value )
        !!(value =~ @regex )
      end

    end

  end
end
