require 'test_helper'

describe PostPolicy::Rule do

  before(:all) do
    SENDER = "foo@example.com"
    RECIPIENT = "bar@example.com"
    ACTION = "REJECT"
  end

  before(:each) do
    @rule = PostPolicy::Rule.new do
      sender { format.value SENDER  }
      recipient { format.value RECIPIENT }
      action ACTION 
    end

  end

  it "should respond_to to_access" do
    @rule.should respond_to( :to_access )
  end

  it "should match given arguments after converting to access" do
    @rule.to_access.match?( :sender => SENDER, :recipient => RECIPIENT ).should == true
  end

  it "should return given action after converting to access" do
    @rule.to_access.action.should == ACTION
  end

end
