

require 'spec_helper'

describe ProyeksiApp::FileCommandContentTypeDetector do
  it 'returns a content type based on the content of the file' do
    tempfile = Tempfile.new('something')
    tempfile.write('This is a file.')
    tempfile.rewind

    assert_equal 'text/plain', ProyeksiApp::FileCommandContentTypeDetector.new(tempfile.path).detect

    tempfile.close
  end

  it 'returns a sensible default when the file command is missing' do
    allow(::Open3).to receive(:capture2).and_raise 'o noes!'
    @filename = '/path/to/something'
    assert_equal 'application/binary',
                 ProyeksiApp::FileCommandContentTypeDetector.new(@filename).detect
  end

  it 'returns a sensible default on the odd chance that run returns nil' do
    allow(::Open3).to receive(:capture2).and_return [nil, 0]
    assert_equal 'application/binary',
                 ProyeksiApp::FileCommandContentTypeDetector.new('windows').detect
  end
end
