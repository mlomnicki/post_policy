require 'test_helper'

describe PostPolicy::Config::Db do
  
  it "should load config from file and build dbi_params" do
    filename = '/tmp/dbconfig' 
    config = {  :host => 'localhost',
                :database => 'postpolicy',
                :user => 'foo',
                :password => 'secret',
                :driver => 'pg' }

    File.open( filename, 'w' ) do |f|
      f.puts config.to_yaml 
    end

    PostPolicy::Config::Db.load( filename )
    PostPolicy::Config::Db.dbconfig.should == config
    dbi_params = ["DBI:#{config[:driver]}:#{config[:database]}", config[:user], config[:password]]
    PostPolicy::Config::Db.dbi_params.should == dbi_params
  
    FileUtils.rm( filename )
  end

end
