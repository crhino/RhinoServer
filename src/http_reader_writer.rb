class RhinoHTTPReaderWriter
  attr_accessor :socket, :buffer, :thread
  def initialize(socket)
    @socket = socket
    @buffer = []
    @thread = Thread.new do
      loop do
        read_loop
      end
    end
  end

  def addr
    socket.addr
  end

  def send(msg)
    socket.puts(msg)
  end

  def get_msg
    sleep(1) until !buffer.empty?
    p "buffer is #{buffer}"
    buffer.pop
  end

  def read_loop
    p "running thread"
    buffer.push(socket.recv(255))
  end

  def close
    socket.close
  end
end
