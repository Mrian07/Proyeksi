

FactoryBot.define do
  factory :default_hourly_rate do
    association :user, factory: :user
    valid_from { Date.today }
    rate { 50.0 }
  end
end
