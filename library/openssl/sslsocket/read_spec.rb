require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

describe "OpenSSL::SSL::SSLSocket#read" do

  before :each do
    @server, @server_socket, @client = SSLSocketSpecs.create_ssl_socket_pair
  end

  after :each do
    @server.close
    @server_socket.close
    @client.close
  end

  it "can read individual bytes" do
    @server_socket.write 'abc'
    @client.read(1).should == 'a'
    @client.read(1).should == 'b'
    @client.read(1).should == 'c'
  end

end

