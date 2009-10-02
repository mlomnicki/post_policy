require 'test_helper'

describe PostPolicy::ACL::Sender do

  it "should match given sender" do
    ds = PostPolicy::DataSource::Value.new( ATTRS[:sender] )
    sender_acl = PostPolicy::ACL::Sender.new( ds )
    sender_acl.match?( ATTRS ).should == true
  end

end

describe PostPolicy::ACL::Recipient do 

  it "should match given recipient" do
    ds = PostPolicy::DataSource::Value.new( ATTRS[:recipient] )
    recipient_acl = PostPolicy::ACL::Recipient.new( ds )
    recipient_acl.match?( ATTRS ).should == true
  end

end
