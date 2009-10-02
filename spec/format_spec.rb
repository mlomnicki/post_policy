require 'test_helper'

describe PostPolicy::Rule::Format do

  before(:each) do
    @klass = PostPolicy::Rule::Format
  end

  it "should return DataSource::Value for format.value" do
    value = "michal.lomnicki@gmail.com"
    ds = @klass.format.value( value )
    ds.class.should == PostPolicy::DataSource::Value
    ds.exists?( value ).should == true
  end

  it "should return DataSource::Regex for format.regex" do
    value = /gmail.com$/
    ds = @klass.format.regex( value )
    ds.class.should == PostPolicy::DataSource::Regex
    ds.exists?( "michal.lomnicki@gmail.com" ).should == true
  end
  
  it "should return DataSource::File for format.file" do
    filename = '/tmp/file_datasource'
    value = "michal.lomnicki@gmail.com"
    File.open( filename, 'w' ) do |f| 
       f.puts value
    end
    ds = @klass.format.file( filename )
    ds.class.should == PostPolicy::DataSource::File
    ds.exists?( value ).should == true
    FileUtils.rm( filename )
  end

end
