require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

describe "OpenSSL::SSL::SSLSocket#read_nonblock" do

  before :each do
    @server, @server_socket, @client = SSLSocketSpecs.create_ssl_socket_pair
  end

  after :each do
    @server.close
    @server_socket.close
    @client.close
  end

  it "raises if the OS buffer is empty" do
    lambda { @client.read_nonblock(1) }.should raise_error(OpenSSL::SSL::SSLError)
  end

  it "reads n bytes from the buffer if we try to read m bytes when n bytes are available and m > n and we try to" do
    @server_socket.write "a"
    @client.read_nonblock(2).should == "a"
  end

  it "reads m bytes from the buffer if n bytes are available and m < n" do
    @server_socket.write "abcd"
    @client.read_nonblock(3).should == "abc"
    @client.read_nonblock(1).should == "d"
  end

  it "allows reading from multiple writes" do
    str1, str2, str3 = 'abcd', 'efgh', 'ijkl'
    expected = str1 + str2 + str3

    @server_socket.write str1
    @server_socket.write str2
    @server_socket.write str3

    actual = ''
    until actual.length == expected.length
      actual << @client.read_nonblock(expected.length - actual.length)
    end

    actual.should == expected
  end

end

