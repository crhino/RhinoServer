require 'socket'


class SimpleHTTPServer < TCPServer
  attr_reader :root

  def initialize(port, root)
    @root = File.absolute_path(root)
    super(port)
  end
end

def main
  server = SimpleHTTPServer.new(8080, ".")
  loop do
    client = server.accept
    client.puts "Please input the passphrase: "
    password = client.gets.chomp
    puts "Passphrase is #{password}, apparently"
    if password != "thing"
      client.puts "Closing connection"
      client.close
      next
    end
    client.puts "You are connected"
    client.puts "Time is #{Time.now}"
    client.puts "my address is #{server.addr}"
    client.puts "my root directory is #{server.root}"
    client.close
  end
end

main
