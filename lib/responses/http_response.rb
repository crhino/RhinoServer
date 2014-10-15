require 'time'

class RhinoHTTPResponse
  attr_reader :conn, :method, :root, :path

  def initialize(conn, method, root, path)
    @conn = conn
    @method = method
    @root = root
    @path = path
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
    conn.send("Content-Type: text/html\r\n")
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
    p "Sending file at path: #{file}"
    File.open(file, "r").each_line do |line|
      conn.send(line)
    end
  end

  def not_found
    not_found_page = File.join(root, "html/not_found.html")
    conn.send("HTTP/1.1 404 Not Found\r\n")
    send_headers(not_found_page)
    send_file(not_found_page)
    conn.send("\r\n")
  end
end
