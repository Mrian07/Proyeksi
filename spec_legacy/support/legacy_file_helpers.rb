

module LegacyFileHelpers
  module_function

  def mock_uploaded_file(name: 'test.txt',
                         content_type: 'text/plain',
                         content: 'test content',
                         binary: false)

    tmp = ::ProyeksiApp::Files.create_temp_file name: name, content: content, binary: binary
    Rack::Test::UploadedFile.new tmp.path, content_type, binary
  end
end
