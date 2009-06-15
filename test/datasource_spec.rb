require 'test_helper'

describe PostPolicy::DataSource::Value do

  it "should allow passing one or multiple values" do
    value = PostPolicy::DataSource::Value.new( 1 )
    value.exists?( 1 ).should == true
    value = PostPolicy::DataSource::Value.new( [1,2] )
    value.exists?( 1 ).should == true
    value.exists?( 2 ).should == true
  end

  it "should match initialized values" do
    GOOD_VALUES = [1,10,100]
    BAD_VALUES = GOOD_VALUES.collect { |v| v * 2 }
    value = PostPolicy::DataSource::Value.new( GOOD_VALUES )
    value.exists?( GOOD_VALUES.first ).should == true
    value.exists?( GOOD_VALUES.last ).should == true
    value.exists?( BAD_VALUES.first ).should == false
    value.exists?( BAD_VALUES.last ).should == false
  end


end
