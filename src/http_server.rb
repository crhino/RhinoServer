require 'socket'
require_relative 'http_reader_writer'


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
end
