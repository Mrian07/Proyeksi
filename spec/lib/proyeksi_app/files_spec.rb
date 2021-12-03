

require 'spec_helper'

describe ProyeksiApp::Files do
  describe 'build_uploaded_file' do
    let(:original_filename) { 'test.png' }
    let(:content_type) { 'image/png' }
    let(:file) do
      ProyeksiApp::Files.create_temp_file(name: original_filename)
    end

    subject { ProyeksiApp::Files.build_uploaded_file(file, content_type) }

    it 'has the original file name' do
      expect(subject.original_filename).to eql(original_filename)
    end

    it 'has the given content type' do
      expect(subject.content_type).to eql(content_type)
    end

    context 'with custom file name' do
      let(:file_name) { 'my-custom-filename.png' }

      subject { ProyeksiApp::Files.build_uploaded_file(file, content_type, file_name: file_name) }

      it 'has the custom file name' do
        expect(subject.original_filename).to eql(file_name)
      end
    end
  end

  describe 'create_uploaded_file' do
    context 'without parameters' do
      let(:file) { ProyeksiApp::Files.create_uploaded_file }

      it 'creates a file with the default name "test.txt"' do
        expect(file.original_filename).to eq 'test.txt'
      end

      it 'creates distinct files even with identical names' do
        file_2 = ProyeksiApp::Files.create_uploaded_file

        expect(file.original_filename).to eq file_2.original_filename
        expect(file.path).not_to eq file_2.path
      end

      it 'writes some default content "test content"' do
        expect(file.read).to eq 'test content'
      end

      it 'set default content type "text/plain"' do
        expect(file.content_type).to eq 'text/plain'
      end
    end

    context 'with a custom name, content and content type' do
      let(:name)         { 'foo.jpg' }
      let(:content)      { 'not-really-a-jpg' }
      let(:content_type) { 'image/jpeg' }

      let(:file) do
        ProyeksiApp::Files.create_uploaded_file name: name,
                                                content: content,
                                                content_type: content_type
      end

      it 'creates a file called "foo.jpg"' do
        expect(file.original_filename).to eq name
      end

      it 'writes the custom content' do
        expect(file.read).to eq content
      end

      it 'sets the content type to "image/jpeg"' do
        expect(file.content_type).to eq content_type
      end
    end

    context 'with binary content' do
      let(:content) { "\xD1\x9B\x86".b }
      let(:binary)  { false }
      let(:file)    { ProyeksiApp::Files.create_uploaded_file content: content, binary: binary }

      it 'fails when the content is not marked as binary' do
        expect { file }.to raise_error(Encoding::UndefinedConversionError)
      end

      context 'with the file denoted as binary' do
        let(:binary) { true }

        it 'succeeds' do
          expect(file.read).to eq content
        end
      end
    end
  end
end
