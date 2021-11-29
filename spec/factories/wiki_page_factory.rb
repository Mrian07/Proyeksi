

FactoryBot.define do
  factory :wiki_page do
    wiki
    sequence(:title) { |n| "Wiki Page No. #{n}" }

    factory :wiki_page_with_content do
      content { association :wiki_content, page: instance }
    end
  end
end
