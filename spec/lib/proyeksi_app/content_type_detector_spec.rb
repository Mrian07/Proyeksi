

require 'spec_helper'

describe ProyeksiApp::ContentTypeDetector do
  it 'gives a sensible default when the name is empty' do
    assert_equal 'application/binary', ProyeksiApp::ContentTypeDetector.new('').detect
  end

  it 'returns the empty content type when the file is empty' do
    tempfile = Tempfile.new('empty')
    assert_equal 'inode/x-empty', ProyeksiApp::ContentTypeDetector.new(tempfile.path).detect
    tempfile.close
  end

  it 'returns content type of file if it is an acceptable type' do
    allow(MIME::Types).to receive(:type_for).and_return([MIME::Type.new('application/mp4'), MIME::Type.new('video/mp4'),
                                                         MIME::Type.new('audio/mp4')])
    allow(::Open3).to receive(:capture2).and_return(['video/mp4', 0])
    @filename = 'my_file.mp4'
    assert_equal 'video/mp4', ProyeksiApp::ContentTypeDetector.new(@filename).detect
  end

  it 'returns the default when exitcode > 0' do
    allow(MIME::Types).to receive(:type_for).and_return([MIME::Type.new('application/mp4'), MIME::Type.new('video/mp4'),
                                                         MIME::Type.new('audio/mp4')])
    allow(::Open3).to receive(:capture2).and_return(['', 1])
    @filename = 'my_file.mp4'
    assert_equal 'application/binary', ProyeksiApp::ContentTypeDetector.new(@filename).detect
  end

  it 'finds the right type in the list via the file command' do
    @filename = "#{Dir.tmpdir}/something.hahalolnotreal"
    File.open(@filename, 'w+') do |file|
      file.puts 'This is a text file.'
      file.rewind
      assert_equal 'text/plain', ProyeksiApp::ContentTypeDetector.new(file.path).detect
    end
    FileUtils.rm @filename
  end

  it 'returns a sensible default if something is wrong, like the file is gone' do
    @filename = '/path/to/nothing'
    assert_equal 'application/binary', ProyeksiApp::ContentTypeDetector.new(@filename).detect
  end

  it 'returns a sensible default when the file command is missing' do
    allow(::Open3).to receive(:capture2).and_raise 'o noes!'
    @filename = '/path/to/something'
    assert_equal 'application/binary', ProyeksiApp::ContentTypeDetector.new(@filename).detect
  end
end
