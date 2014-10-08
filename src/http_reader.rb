class RhinoHTTPReader
  def initialize(socket)
    @socket = socket
    @buffer = [] 
  end

  def get_mesg
    @buffer.pop
  end

  def read_loop
    @buffer.push(socket.recv)
  end
end
