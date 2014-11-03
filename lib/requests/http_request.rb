require 'uri'
require_relative '../http_headers'

class RhinoHTTPRequest
  attr_reader :conn, :method, :uri, :version, :headers

  def initialize(conn)
    @conn = conn
  end

  def parse_request
    http_method = conn.recv_line.split
    @method = http_method[0]
    uri_string = http_method[1]
    @version = http_method[2]

    parser = URI::Parser.new
    @uri = parser.parse(uri_string)

    @headers = RhinoHTTPHeaders.new
    headers.parse(read_headers)

    # Remove CRLF separating either the header and body or the next Request
    conn.recv_line
  end

  def read_headers
    headers_ary = []

    http_line = conn.recv_line
    while http_line != "\r\n" do
      headers_ary << http_line
      http_line = conn.recv_line
    end
    headers_ary
  end
end
