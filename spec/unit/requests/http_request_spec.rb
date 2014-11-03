require 'rspec'
require_relative '../../../lib/requests/http_request'
require_relative '../../../lib/http_reader_writer'

describe 'RhinoHTTPRequest' do
  let(:conn) { instance_double(RhinoHTTPReaderWriter) }
  let(:request) { RhinoHTTPRequest.new(conn) }

  describe '#parse_request' do
    before do
      allow(conn).to receive(:recv_line).
        and_return("GET http://example.com/path HTTP/1.1", "Foo: Bar\r\n",  "\r\n")
    end

    it 'reads the method, url, and version' do
      request.parse_request

      expect(request.method).to eq 'GET'
      expect(request.uri.host).to eq 'example.com'
      expect(request.uri.path).to eq '/path'
      expect(request.version).to eq 'HTTP/1.1'
    end

    it 'creates a headers object with correct headers' do
      request.parse_request

      expect(request.headers['Foo']).to eq 'Bar'
    end
  end

  describe '#read_headers' do
    before do
      allow(conn).to receive(:recv_line).
        and_return("Foo: Bar\r\n", "\r\n")
    end

    it 'puts each CRLF line in an array, stopping at a CRLF' do
      array = request.read_headers

      expect(array).to eq ["Foo: Bar\r\n"]
    end
  end
end
