

FactoryBot.define do
  factory :query do
    project
    user factory: :user
    sequence(:name) { |n| "Query #{n}" }

    factory :public_query do
      is_public { true }
      sequence(:name) { |n| "Public query #{n}" }
    end

    factory :private_query do
      is_public { false }
      sequence(:name) { |n| "Private query #{n}" }
    end

    factory :global_query do
      project { nil }
      is_public { true }
      sequence(:name) { |n| "Global query #{n}" }
    end

    callback(:after_build) { |query| query.add_default_filter }
  end
end
