require_relative 'http_server'

def main
  server = RhinoHTTPServer.new(8080, "./assets")
  server.start
end

main
