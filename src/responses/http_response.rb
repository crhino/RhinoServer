class RhinoHTTPResponse
  attr_reader :conn, :method, :root, :path

  def initialize(conn, method, root, path)
    @conn = conn
    @method = method
    @root = root
    @path = path
  end

  def send
    file = File.join(root, path)
    p "Sending file at path: #{file}"
    send_file(file) unless !File.exists?(file) || !File.directory?(file)
  end

  def send_file(file)
    File.open(file, "r").each_line do |line|
      conn.send(line)
    end
  end
end
