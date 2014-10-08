require 'socket'


class RhinoHTTPServer < TCPServer
  attr_reader :root

  def initialize(port, root)
    @root = File.absolute_path(root)
    @readers = []
    super(port)
  end

  def accept
    socket = super
    @readers.push(RhinoHTTPReader.new(socket))
  end
end
