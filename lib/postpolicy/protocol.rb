require 'set'

module PostPolicy
  class Protocol
 
    PROTOCOLS = %w(ESMTP SMTP)
    STATES = %w(CONNECT EHLO HELO MAIL RCPT DATA END-OF-MESSAGE VRFY ETRN)
    
    TERMINATOR = "\n\n"

    attr_reader :attributes

    @@required_request_attributes = [:request, :protocol_state, :protocol_name, :helo_name, :queue_id, :sender, :recipient, :recipient_count, :client_address, :client_name, :reverse_client_name, :instance].to_set # Postfix 2.1 and later
  
    @@request_attributes = @@required_request_attributes + 
          [:sasl_method, :sasl_username, :sasl_sender, :size, :ccert_subject, :ccert_issuer, :ccert_fingerprint, # Postifx 2.2 and later
          :encryption_protocol, :encryption_cipher, :encryption_keysize, :etrn_domain, # Postifx 2.3 and later
          :stress].to_set # Postifx 2.5 and later 
  
    def initialize
      @attributes = {}
      $stdout.sync = true
      @buffer = []
    end

    def start!
      while line = gets do
        receive_line( line.chomp )
      end
    end

    def receive_line( line )
      unless line.empty?
        @buffer << line
      else
        Logger.info @buffer.inspect if VERBOSE
        parse_request
        @buffer.clear
      end
    end

    def response( action )
      puts "action=#{action}#{TERMINATOR}" unless POST_POLICY_ENV == 'test'
    end
    
    protected
    def parse_request
      @buffer.each do |line|
        key, value = line.split( '=' )
        @attributes[key.to_sym] = value
      end
      return false if( sanitize_arguments == false || validate_arguments == false )
      run_actions
    end

    def run_actions
      am = PostPolicy::AccessManager.new
      am.callback do |args| 
        am.check( args ) do |action|  
          Logger.debug "Returning response #{action}" if VERBOSE
          response( action )
        end
      end
      am.set_deferred_status :succeeded, @attributes
    end

    def sanitize_arguments
      missing_attributes = @@required_request_attributes - @attributes.keys.to_set
      unless missing_attributes.empty?     
        Logger.err "missing #{missing_attributes.to_a.join( ',' )}" 
        return false
      end
      unknown_attributes = @attributes.keys.to_set - @@request_attributes
      unless unknown_attributes.empty?
        Logger.warn( 'Unknown attributes in policy request %s' % unknown_attributes.to_a.join( ',' ) ) if VERBOSE
      end
      unknown_attributes.each { |attr| @attributes.delete( attr ) }
      true
    end
 

    def validate_arguments
      unless @attributes[:request] == "smtpd_access_policy"
        Logger.err( 'only smtpd_access_policy request allowed' )
        return false
      end
      unless PROTOCOLS.include?( @attributes[:protocol_name] )
        Logger.err( "only #{PROTOCOLS.join(',')} protocols allowed" )
        return false
      end
      unless STATES.include?( @attributes[:protocol_state] )
        Logger.err( "only #{STATES.join(',')} states allowed" )
        return false
      end

      true
    end

  end
end
