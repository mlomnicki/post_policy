require 'test_helper'

GOOD_VALUES = ["michal@lomnicki.com.pl", "foo@example.com", "bar@baz.com"]
BAD_VALUES = ["michal@bar.com", "bar@baz.net", "foo@bar.baz"]

describe PostPolicy::DataSource::Value do

  it "should allow passing one or multiple values" do
    ds = PostPolicy::DataSource::Value.new( 1 )
    ds.exists?( 1 ).should == true
    ds = PostPolicy::DataSource::Value.new( [1,2] )
    ds.exists?( 1 ).should == true
    ds.exists?( 2 ).should == true
  end

  it "should match initialized dss" do
    ds = PostPolicy::DataSource::Value.new( GOOD_VALUES )
    ds.exists?( GOOD_VALUES.first ).should == true
    ds.exists?( GOOD_VALUES.last ).should == true
    ds.exists?( BAD_VALUES.first ).should == false
    ds.exists?( BAD_VALUES.last ).should == false
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

describe PostPolicy::DataSource::Regex do

  it "should match regex" do
    ds = PostPolicy::DataSource::Regex.new( /^michal@.*\.pl$/ )
    ds.exists?( "michal@lomnicki.com.pl" ).should == true
    ds.exists?( "foo@lomnicki.com.pl" ).should == false
  end

end
