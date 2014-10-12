require_relative 'http_server'

def main
  server = RhinoHTTPServer.new(8080, ".")
  loop do
    conn = server.accept
    puts conn
    conn.send "You are connected"
    msg = ""
    while msg != "\r\n" do
      msg = conn.recv_line
      conn.send msg
    end
    conn.send "Time is #{Time.now}"
    conn.send "my address is #{conn.addr}"
    conn.send "my root directory is #{server.root}"
    conn.send "Closing connection..."
    conn.close
  end
end

main
