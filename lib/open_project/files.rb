

module OpenProject
  module Files
    module_function

    ##
    # Creates a temp file with the given file name.
    # It will reside in some temporary directory.
    def create_temp_file(name: 'test.txt', content: 'test content', binary: false)
      tmp = Tempfile.new name
      path = Pathname(tmp)

      tmp.delete # delete temp file
      path.mkdir # create temp directory

      file_path = path.join name
      File.open(file_path, 'w' + (binary ? 'b' : '')) do |f|
        f.write content
      end

      File.new file_path
    end

    def build_uploaded_file(tempfile, type, binary: true, file_name: nil)
      uploaded_file = Rack::Multipart::UploadedFile.new tempfile.path,
                                                        type,
                                                        binary
      if file_name
        # I wish I could set the file name in a better way *sigh*
        uploaded_file.instance_variable_set(:@original_filename, file_name)
      end

      uploaded_file
    end

    def create_uploaded_file(name: 'test.txt',
                             content_type: 'text/plain',
                             content: 'test content',
                             binary: false)

      tmp = create_temp_file name: name, content: content, binary: binary
      build_uploaded_file tmp, content_type, binary: binary
    end
  end
end
