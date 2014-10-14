require 'uri'

class RhinoHTTPRequest
  attr_reader :conn, :method, :uri, :version

  def initialize(conn)
    @conn = conn
    parse_request
  end

  def parse_request
    http_method = conn.recv_line.split
    @method = http_method[0]
    uri_string = http_method[1]
    @version = http_method[2]

    parser = URI::Parser.new
    @uri = parser.parse(uri_string)
  end
end
