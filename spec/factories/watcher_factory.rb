

FactoryBot.define do
  factory :watcher do
    association :watchable
    association :user

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
