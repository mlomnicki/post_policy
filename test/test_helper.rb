$LOAD_PATH.unshift File.join( File.dirname( __FILE__ ), '../lib' )
require 'postpolicy'

POST_POLICY_ENV = ENV['POST_POLICY_ENV'] || "test"

ATTRS = { 
  :request => "smtpd_access_policy",
  :protocol_state => "RCPT",
  :protocol_name => "SMTP",
  :helo_name => "some.domain.tld",
  :queue_id => "8045F2AB23",
  :sender => "foo@bar.tld",
  :recipient => "bar@foo.tld",
  :recipient_count => "0",
  :client_address => "1.2.3.4",
  :client_name => "another.domain.tld",
  :reverse_client_name => "another.domain.tld",
  :instance => "123.456.7"
}

Object.send(:remove_const, :Logger)

module Logger
  def self.method_missing(symbol, *args)
    #simpy do nothing
  end
end
