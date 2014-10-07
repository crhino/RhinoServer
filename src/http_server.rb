require 'socket'


class RhinoHTTPServer < TCPServer
  attr_reader :root

  def initialize(port, root)
    @root = File.absolute_path(root)
    super(port)
  end
end

