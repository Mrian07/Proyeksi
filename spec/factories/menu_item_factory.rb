

FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Item No. #{n}" }
    sequence(:title) { |n| "Menu item Title #{n}" }

    factory :wiki_menu_item, class: 'MenuItems::WikiMenuItem' do
      wiki

      sequence(:title) { |n| "Wiki Title #{n}" }

      trait :with_menu_item_options do
        index_page { true }
        new_wiki_page { true }
      end

      factory :wiki_menu_item_with_parent do
        callback(:after_build) do |wiki_menu_item|
          parent = FactoryBot.build(:wiki_menu_item, wiki: wiki_menu_item.wiki)
          wiki_menu_item.wiki.wiki_menu_items << parent
          wiki_menu_item.parent = parent
        end
      end
    end

    factory :query_menu_item, class: 'MenuItems::QueryMenuItem' do
      query

      name { query.normalized_name }
      title { query.name }

      navigatable_id { query.id }
    end
  end
end
