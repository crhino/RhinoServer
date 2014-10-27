require 'rspec'
require_relative '../../lib/http_server'

describe 'RhinoHTTPServer' do
  let!(:server) do
    Thread.new do
      RhinoHTTPServer.new(12345, "../../assets").start
    end
  end

  after do
    server.kill
  end

  it 'accepts incoming TCP connections on specified port' do
    expect{ TCPSocket.new('localhost', 12345) }.not_to raise_error
  end
end
