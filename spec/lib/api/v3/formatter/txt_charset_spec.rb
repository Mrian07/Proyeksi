

require 'spec_helper'

describe API::V3::Formatter::TxtCharset do
  let(:umlaut_object_ascii) { 'ümläutß'.force_encoding('ASCII-8BIT') }
  let(:umlaut_object_utf8) { umlaut_object_ascii.force_encoding('utf-8') }
  let(:env) { {} }

  describe '#call' do
    it 'returns the object (string) encoded in the charset defined in env' do
      env['CONTENT_TYPE'] = 'text/plain; charset=UTF-8'

      expect(described_class.call(umlaut_object_ascii.dup, env)).to eql umlaut_object_utf8
    end

    it 'returns the object (string) in default encoding if nothing defined in env' do
      expect(described_class.call(umlaut_object_ascii.dup, env)).to eql umlaut_object_utf8
    end

    it 'returns the object (string) unchanged if invalid charset is provided in env' do
      env['CONTENT_TYPE'] = 'text/plain; charset=bogus'

      expect(described_class.call(umlaut_object_ascii.dup, env)).to eql umlaut_object_ascii
    end
  end
end
