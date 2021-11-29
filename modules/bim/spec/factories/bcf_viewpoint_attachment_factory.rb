

FactoryBot.define do
  factory :bcf_viewpoint_attachment, class: 'Attachment' do
    description  { "snapshot" }
    filename     { "image.png" }
    content_type { "image/jpeg" }
    author       { User.current }
    file do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/image.png"),
        'image/png',
        true
      )
    end
  end
end
