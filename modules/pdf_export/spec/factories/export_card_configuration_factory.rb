

FactoryBot.define do
  factory :export_card_configuration do
    name { "Config 1" }
    description { "This is a description" }
    rows do
      "group1:\n  has_border: false\n  rows:\n    row1:\n      height: 50\n      priority: 1\n      columns:\n        id:\n          has_label: false"
    end
    per_page { 5 }
    page_size { "A4" }
    orientation { "landscape" }
  end

  factory :default_export_card_configuration, class: 'ExportCardConfiguration' do
    name { "Default" }
    description { "This is a description" }
    active { true }
    rows do
      "group1:\n  has_border: false\n  rows:\n    row1:\n      height: 50\n      priority: 1\n      columns:\n        id:\n          has_label: false"
    end
    per_page { 5 }
    page_size { "A4" }
    orientation { "landscape" }
  end

  factory :invalid_export_card_configuration, class: 'ExportCardConfiguration' do
    name { "Invalid" }
    description { "This is a description" }
    rows { "row1" }
    per_page { "string" }
    page_size { "asdf" }
    orientation { "qwer" }
  end

  factory :active_export_card_configuration, class: 'ExportCardConfiguration' do
    name { "Config active" }
    description { "This is a description" }
    active { true }
    rows do
      "group1:\n  has_border: false\n  rows:\n    row1:\n      height: 50\n      priority: 1\n      columns:\n        id:\n          has_label: false"
    end
    per_page { 5 }
    page_size { "A4" }
    orientation { "landscape" }
  end

  factory :inactive_export_card_configuration, class: 'ExportCardConfiguration' do
    name { "Config inactive" }
    description { "This is a description" }
    active { false }
    rows do
      "group1:\n  has_border: false\n  rows:\n    row1:\n      height: 50\n      priority: 1\n      columns:\n        id:\n          has_label: false"
    end
    per_page { 5 }
    page_size { "A4" }
    orientation { "landscape" }
  end
end
