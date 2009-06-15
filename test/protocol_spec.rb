require 'stringio'
require 'test_helper' 

describe PostPolicy::Protocol do
  
  before(:each) do
    @protocol = PostPolicy::Protocol.new
  end

  it "should parse attributes" do 
    form_string( ATTRS ).each_line { |l| @protocol.receive_line( l.strip ) }
    @protocol.attributes.should == ATTRS
  end

  it "should discard unknown attributes" do
    ATTRS.merge( :foo => 'bar', :bar => 'baz' ).each_pair { |k,v| @protocol.receive_line( [k,v].join( '=' ) ) }
    form_string( ATTRS ).each_line { |l| @protocol.receive_line( l.strip ) }
    @protocol.attributes.should == ATTRS
  end

  #it "should return false on missing attributes" do
  #  ATTRS.reject { |k,v| k == :protocol_name }.each_pair { |k,v| @protocol.receive_line( [k,v].join( '=' ) ) }
  #  form_string( ATTRS ).each_line { |l| @protocol.receive_line( l.strip ) }
  #  @protocol.receive.should == false
  #end

  #it "should validate arguments" do
  #  ATTRS.merge( :request => "bar" ).each_pair { |k,v| @protocol.receive_line( [k,v].join( '=' ) ) }
  #  form_string( ATTRS ).each_line { |l| @protocol.receive_line( l.strip ) }
  #  @protocol.receive.should == false
  #end

  #it "should terminate response" do
  #  @protocol.response("dunno").should == "action=dunno\n\n"
  #end

  protected
  def form_string( args )
    StringIO.new( args.each.inject("") { |str, kv| str << (kv.join('=') + "\n") } << "\n" )
  end

end
