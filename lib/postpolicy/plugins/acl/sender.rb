module PostPolicy
  module ACL

    class Sender < Base

      def match?( args )
        datasource.exists? args[:sender] 
      end

    end

  end
end
