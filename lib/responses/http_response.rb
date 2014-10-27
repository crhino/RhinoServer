require 'time'
require 'filemagic'

class RhinoHTTPResponse
  attr_reader :conn, :method, :root, :path, :mime_type, :not_found_body

  def initialize(conn, method, root, path)
    @conn = conn
    @method = method
    @root = root
    @path = path
    @mime_type = FileMagic.mime
    @not_found_body = File.join(root, "html/not_found.html")
  end

  def send_response
    file = File.join(root, path)
    if !File.exists?(file) || File.directory?(file)
      not_found
    else
      ok(file)
    end
  end

  def send_headers(file)
    conn.send("Content-Type: #{mime_type.file(file)}\r\n")
    conn.send("Content-Length: #{File::Stat.new(file).size}\r\n")
    conn.send("Date: #{Time.now.httpdate}\r\n")
    conn.send("Server: rhino\r\n")
    conn.send("\r\n")
  end

  def ok(file)
    conn.send("HTTP/1.1 200 Ok\r\n")
    send_headers(file)
    send_file(file)
    conn.send("\r\n")
  end

  def send_file(file)
    File.open(file, "r").each_line do |line|
      conn.send(line)
    end
  end

  def not_found
    conn.send("HTTP/1.1 404 Not Found\r\n")
    send_headers(not_found_body)
    send_file(not_found_body)
    conn.send("\r\n")
  end
end
