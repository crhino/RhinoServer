require 'rspec'
require_relative '../../../lib/responses/http_response'
require_relative '../../../lib/http_reader_writer'

describe 'RhinoHTTPResponse' do
  let(:conn) { instance_double(RhinoHTTPReaderWriter) }
  let(:method) { 'GET' }
  let(:root) { File.absolute_path('assets') }
  let(:path) { '/hello' }
  let(:not_found_body) { File.join(root, 'html/not_found.html') }
  let(:response) { RhinoHTTPResponse.new(conn, method, root, path) }
  let(:passed_args) { [] }
  let(:file) { File.join(root, path) }

  before do
    allow(conn).to receive(:send) do |string|
      passed_args << string
    end
  end

  describe '#send_headers' do
    it 'sends the correct Content-Type header' do
      response.send_headers(file)

      expect(passed_args).to include("Content-Type: text/plain; charset=us-ascii\r\n")
    end

    context 'when the file is an HTML page' do
      let(:path) { '/html/sample.html' }

      it 'sends a Content-Type header of text/html' do
        response.send_headers(file)

        expect(passed_args).to include("Content-Type: text/html; charset=us-ascii\r\n")
      end
    end

    it 'sends the correct length in the Content-Length header' do
      response.send_headers(file)

      expect(passed_args).to include("Content-Length: 14\r\n")
    end
    it 'sends the date' do
      response.send_headers(file)

      expect(passed_args).to include("Date: #{Time.now.httpdate}\r\n")
    end
    it 'identifies itself' do
      response.send_headers(file)

      expect(passed_args).to include("Server: rhino\r\n")
    end
  end

  describe '#send_response' do
    context 'when the requested file is available' do
      it 'sends a 200 Ok and the file' do
        response.send_response

        expect(passed_args).to include("HTTP/1.1 200 Ok\r\n")
        expect(passed_args).to include("Hello, World!\n")
      end
    end

    context 'when the requested file is not available' do
      let(:path) { 'does_not_exist' }
      it 'sends a 404 Not Found' do
        response.send_response

        expect(passed_args).to include("HTTP/1.1 404 Not Found\r\n")
      end
    end
  end

  describe '#ok' do
    it 'writes a 200 Ok response to the connection' do
      response.ok(file)

      expect(passed_args).to include("HTTP/1.1 200 Ok\r\n")
    end

    it 'sends the specified file' do
      response.ok(file)

      File.open(file, 'r').each_line do |line|
        expect(passed_args).to include(line)
      end
    end

    it 'ends the response with a CRLF line' do
      response.ok(file)

      expect(passed_args).to include("\r\n")
    end
  end

  describe '#not_found' do
    it 'writes a 404 Not Found response to the connection' do
      response.not_found

      expect(passed_args).to include("HTTP/1.1 404 Not Found\r\n")
    end
    it 'sends a 404 page' do
      response.not_found

      File.open(not_found_body, 'r').each_line do |line|
        expect(passed_args).to include(line)
      end
    end
    it 'ends the response with a CRLF line' do
      response.not_found

      expect(passed_args).to include("\r\n")
    end
  end
end
