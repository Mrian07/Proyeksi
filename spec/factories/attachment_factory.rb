

require Rails.root + 'spec/support/file_helpers'

FactoryBot.define do
  factory :attachment do
    container factory: :work_package
    author factory: :user
    description { nil }

    transient do
      filename { nil }
    end

    content_type { 'application/binary' }
    sequence(:file) do |n|
      FileHelpers.mock_uploaded_file name: filename || "file-#{n}.test",
                                     content_type: content_type,
                                     binary: true
    end

    callback(:after_build, :after_stub) do |attachment, evaluator|
      attachment.filename = evaluator.filename if evaluator.filename
    end

    factory :wiki_attachment do
      container factory: :wiki_page_with_content
    end

    factory :attached_picture do
      content_type { 'image/jpeg' }
    end

    factory :pending_direct_upload do
      digest { "" }
      downloads { -1 }
      created_at { DateTime.now - 2.weeks }
    end
  end
end
