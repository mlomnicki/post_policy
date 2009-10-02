require 'test_helper'

describe PostPolicy::Config::Db do
  
  it "should load config from file and build dbi_params" do
    filename = '/tmp/dbconfig' 
    config = {  :host => 'localhost',
                :database => 'postpolicy',
                :user => 'foo',
                :password => 'secret',
                :port => 5432,
                :driver => 'postgres' }

    File.open( filename, 'w' ) do |f|
      f.puts config.to_yaml 
    end

    PostPolicy::Config::Db.load( filename )
    PostPolicy::Config::Db.dbconfig.should == config
    dbi_params = "#{config[:driver]}://#{config[:user]}:#{config[:password]}@#{config[:host]}:#{config[:port]}/#{config[:database]}"
    PostPolicy::Config::Db.dbi_params.should == dbi_params
  
    FileUtils.rm( filename )
  end

end
