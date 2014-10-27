require 'rspec'
require 'timeout'
require_relative '../../lib/http_reader_writer'

describe 'RhinoHTTPReaderWriter' do
  let(:socket) { double(:socket) }
  let(:buffer) { double(:buffer) }
  let(:reader_writer) { RhinoHTTPReaderWriter.new(socket, buffer) }

  describe '#peek' do
    context 'when the buffer is empty' do
      let(:buffer) { [] }

      it 'blocks until a line is pushed onto the buffer' do
        allow(buffer).to receive(:empty?).and_return(true)
        expect {
          Timeout::timeout(2) do
            reader_writer.peek
          end
        }.to raise_error(Timeout::Error)
      end
    end

    context 'when the buffer is not empty' do
      let(:buffer) { ["first"] }

      it 'allows you to look at the first buffer entry without removing it' do
        expect(reader_writer.peek).to eq "first"
      end
    end
  end

  describe '#recv_line' do
    context 'when the buffer is empty' do
      let(:buffer) { [] }
      it 'blocks until a line is pushed onto the buffer' do
        expect {
          Timeout::timeout(2) do
            reader_writer.recv_line
          end
        }.to raise_error(Timeout::Error)
      end
    end

    context 'when the buffer is not empty' do
      let(:buffer) { ["shift"] }

      it 'returns the first item in the buffer' do
        expect(reader_writer.recv_line).to eq "shift"
      end
    end
  end

  describe '#find_crlf' do
    let(:peek_str) { "abc123"*256 + "\r\n"}
    let!(:str_bytes) { peek_str.bytesize }

    it 'returns the number of bytes until the next CRLF' do
      allow(socket).to receive(:recv) do |num_bytes, *args|
          peek_str.slice!(0, num_bytes)
      end

      num_bytes = reader_writer.find_crlf
    end
  end
end
