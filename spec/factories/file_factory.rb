

FactoryBot.define do
  ##
  # Yields fixture files.
  factory :file do
    # Skip the create callback to be able to use non-AR models. Otherwise FactoryBot will
    # try to call #save! on any created object.
    skip_create

    name { 'textfile.txt' }

    initialize_with do
      new "#{Rails.root}/spec/fixtures/files/#{name}"
    end
  end

  factory :uploaded_file, class: 'Rack::Multipart::UploadedFile' do
    skip_create

    name { 'test.txt' }
    content { 'test content' }
    content_type { 'text/plain' }
    binary { false }

    initialize_with do
      FileHelpers.mock_uploaded_file(
        name: name,
        content: content,
        content_type: content_type,
        binary: binary
      )
    end

    factory :uploaded_jpg do
      name { 'test.jpg' }
      content { "\xFF\xD8\xFF\xE0\u0000\u0010JFIF\u0000\u0001\u0001\u0001\u0000H" }
      content_type { 'image/jpeg' }
      binary { true }
    end
  end
end
