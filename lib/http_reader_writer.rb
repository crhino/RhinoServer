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

  def empty_buffer?
    buffer.empty?
  end

  def peek
    buffer.first
  end

  def recv_line
    sleep(1) until !buffer.empty?
    p "buffer is #{buffer}"
    p "buffer length is #{buffer.length}"
    buffer.shift
  end

  def read_loop
    p "running thread"
    line = read_line
    buffer.push(line)
  end

  def find_crlf
    num_bits = 256
    peeked = socket.recv(num_bits, Socket::MSG_PEEK)
    str_split_array = peeked.split(/(\r\n)/, 2)
    while str_split_array.length < 2 do
      num_bits = num_bits << 1
      peeked = socket.recv(num_bits, Socket::MSG_PEEK)
      str_split_array = peeked.split(/(\r\n)/, 2)
    end
    str_split_array[0].length + 2
  end

  def read_line
    socket.recv(find_crlf)
  end

  def close
    p "Closing socket..."
    socket.close
    thread.kill
    p "Socket closed."
  end
end
