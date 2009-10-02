# the simplest PostPolicy server using DSL
#
# require 'post_policy'
#
# PostPolicy::Server.run do
#
#   rule do
#     sender { format.value "michal.lomnicki@gmail.com" }
#     action "REJECT"
#   end
#
# end
module PostPolicy

  class Server
    
    def self.run( &block )
      Rule.class_eval( &block )
      PostPolicy::Protocol.new.start!
    end

  end

end
