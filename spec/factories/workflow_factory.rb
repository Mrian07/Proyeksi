

FactoryBot.define do
  factory :workflow do
    old_status factory: :status
    new_status factory: :status
    role

    factory :workflow_with_default_status do
      old_status factory: :default_status
    end
  end
end
