module PostPolicy

  class Access
  
    def initialize( acls, action )
      @acls = acls
      @action = action
    end

    def match?( args )
      @acls.all? { |acl| acl.match?( args ) }
    end

    def action
      @action
    end

  end

end
