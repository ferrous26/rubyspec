require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

describe "OpenSSL::SSL::SSLSocket#write_nonblock" do

  before :each do
    @server, @server_socket, @client = SSLSocketSpecs.create_ssl_socket_pair
  end

  after :each do
    @server.close
    @server_socket.close
    @client.close
  end

  it "raises if the OS buffer becomes full" do
    lambda do
      loop do
        @client.write_nonblock("hi") 
      end
    end.should raise_error(OpenSSL::SSL::SSLError)
  end

  it "writes m bytes to the buffer if n bytes can be written and m < n" do
    string = "abc"
    @server_socket.write_nonblock(string).should == string.length
    @client.read(string.length).should == string
  end

  it "allows writing consecutively and can be successfully read later" do
    strs = ['abcd', 'efgh', 'ijkl']
    expected = strs.join('')

    strs.each do |str|
      written = 0
      until written == str.length
        written += @server_socket.write_nonblock(str[written..-1])
      end
    end

    @client.read(expected.length).should == expected
  end

end

