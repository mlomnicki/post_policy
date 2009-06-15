module PostPolicy
  module ACL

    class Recipient < Base
      
      def match?( args )
        datasource.exists? args[:recipient]
      end

    end

  end
end
