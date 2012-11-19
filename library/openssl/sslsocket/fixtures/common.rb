require 'openssl'
require 'socket'

module SSLSocketSpecs

  CERT = OpenSSL::X509::Certificate.new File.read File.expand_path("../cert.pem", __FILE__)
  KEYS = OpenSSL::PKey::RSA.new File.read File.expand_path("../keys.pem", __FILE__)

  def self.create_ssl_socket_pair
    server_ctx             = OpenSSL::SSL::SSLContext.new
    server_ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    server_ctx.cert        = CERT
    server_ctx.key         = KEYS
    server_ctx.ciphers     = 'eNULL:!MD5' # JRuby GH-382

    server     = TCPServer.new 0
    ssl_server = OpenSSL::SSL::SSLServer.new server, server_ctx

    client_ctx             = OpenSSL::SSL::SSLContext.new
    client_ctx.ciphers     = 'eNULL:!MD5' # JRuby GH-382

    client     = TCPSocket.new 'localhost', server.addr[1]
    ssl_client = OpenSSL::SSL::SSLSocket.new client, client_ctx

    Thread.new do
      ssl_client.connect
    end
    ssl_server_socket = ssl_server.accept

    [ssl_server, ssl_server_socket, ssl_client]
  end

end

