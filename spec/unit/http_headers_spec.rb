require 'rspec'
require_relative '../../lib/http_headers'

describe 'RhinoHTTPHeaders' do
  let(:header) { RhinoHTTPHeaders.new }

  describe '#parse' do
    let(:header_array) do
      ["Foo: Bar\r\n", "Baz: Hoo\r\n"]
    end

    before do
      header.parse(header_array)
    end

    it 'parses an array of HTTP headers' do
      expect(header['Foo']).to eq('Bar')
      expect(header['Baz']).to eq('Hoo')
    end
  end
end
