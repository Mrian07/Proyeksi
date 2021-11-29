

FactoryBot.define do
  factory :relation do
    from factory: :work_package
    to { FactoryBot.build(:work_package, project: from.project) }
    relation_type { 'relates' } # "relates", "duplicates", "duplicated", "blocks", "blocked", "precedes", "follows"
    delay { nil }
    description { nil }
  end

  factory :follows_relation, parent: :relation do
    relation_type { 'follows' }
    delay { 0 }
  end

  factory :hierarchy_relation, parent: :relation do
    relation_type { 'hierarchy' }
  end
end
