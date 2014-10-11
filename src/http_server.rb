require 'socket'
require_relative 'http_reader_writer'


class RhinoHTTPServer
  attr_reader :root

  def initialize(port, root)
    @root = File.absolute_path(root)
    @readers = []
    @port = port
  end

  def conn
    RhinoHTTPReaderWriter.new(@port)
  end
end
