

FactoryBot.define do
  factory :changeset do
    sequence(:revision) { |n| n.to_s }
    committed_on { Time.now }
    commit_date { Date.today }
  end
end
