require 'test_helper'

GOOD_VALUES = ["michal@lomnicki.com.pl", "foo@example.com", "bar@baz.com"]
BAD_VALUES = ["michal@bar.com", "bar@baz.net", "foo@bar.baz"]

describe PostPolicy::DataSource::Value do

  it "should allow passing one or multiple values" do
    value = PostPolicy::DataSource::Value.new( 1 )
    value.exists?( 1 ).should == true
    value = PostPolicy::DataSource::Value.new( [1,2] )
    value.exists?( 1 ).should == true
    value.exists?( 2 ).should == true
  end

  it "should match initialized values" do
    value = PostPolicy::DataSource::Value.new( GOOD_VALUES )
    value.exists?( GOOD_VALUES.first ).should == true
    value.exists?( GOOD_VALUES.last ).should == true
    value.exists?( BAD_VALUES.first ).should == false
    value.exists?( BAD_VALUES.last ).should == false
  end

end

describe PostPolicy::DataSource::File do

  it "should read from file" do
    File.open( '/tmp/file_datasource', 'w' ) do |f| 
      GOOD_VALUES.each { |value| f.puts value }
    end
    ds = PostPolicy::DataSource::File.new( '/tmp/file_datasource' )
    GOOD_VALUES.each do |value|
      ds.exists?( value ).should == true
    end
    BAD_VALUES.each do |value|
      ds.exists?( value ).should == false
    end
  end

end
