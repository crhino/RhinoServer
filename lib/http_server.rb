require 'socket'
require_relative 'http_reader_writer'
require_relative 'requests/http_request'
require_relative 'responses/http_response'


class RhinoHTTPServer < TCPServer
  attr_reader :root

  def initialize(port, root)
    super(port)
    @root = File.absolute_path(root)
    @readers = []
    @port = port
  end

  def accept
    socket = super
    RhinoHTTPReaderWriter.new(socket)
  end

  def start
    loop do
      conn = accept
      req = RhinoHTTPRequest.new(conn)
      method = req.method
      path = req.uri.path
      res = RhinoHTTPResponse.new(conn, method, root, path)
      res.send_response
      conn.close
    end
  end
end
