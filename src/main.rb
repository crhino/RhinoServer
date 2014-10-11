require_relative 'http_server'

def main
  server = RhinoHTTPServer.new(8080, ".")
  conn = server.conn
  loop do
    conn.accept
    puts conn
    conn.send "Please input the passphrase: "
    password = conn.get_msg.chomp
    puts "Passphrase is #{password}, apparently"
    if password != "thing"
      conn.send "Closing connection"
      conn.close
      next
    end
    conn.send "You are connected"
    conn.send "Time is #{Time.now}"
    conn.send "my address is #{conn.addr}"
    conn.send "my root directory is #{server.root}"
    puts "#{conn.get_msg}"
    conn.close
  end
end

main
