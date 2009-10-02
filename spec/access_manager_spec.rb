require 'test_helper'

CONFIG = {
  "acl" =>  {
    "michal-lomnicki" => {
      "sender" => "michal@lomnicki.com.pl"
    },
    "foo-to-bar" => { 
      "sender" => "foo",
      "recipient" => "bar"
    }
  },

  "action" => { "reject" => "REJECT", "defer" => "DEFER_IF_PERMIT" },
  "access" => { 
    "reject" => "michal-lomnicki",
    "defer" => "foo-to-bar"
  }
}

describe PostPolicy::AccessManager do 

  before(:all) do
    PostPolicy::Config.load( CONFIG )
    @am = PostPolicy::AccessManager.new
  end

  it "should reject michal@lomnicki.com.pl" do
    @am.check( { :sender => "michal@lomnicki.com.pl" } ) do |action|
      action.should == "REJECT"
    end
  end

  it "should defer foo to bar" do
    @am.check( { :sender => "foo", :recipient => "bar" } ) do |action|
      action.should == "DEFER_IF_PERMIT"
    end
  end

  # on any other acl default action should be given
  it "should return default action on bar to foo" do
    @am.check( { :sender => "bar", :recipient => "foo" } ) do |action|
      action.should == PostPolicy::AccessManager::DEFAULT_ACTION
    end
  end

end
