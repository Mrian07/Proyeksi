

FactoryBot.define do
  factory :type do
    sequence(:position)
    name { |a| "Type No. #{a.position}" }
    description { nil }
    created_at { Time.now }
    updated_at { Time.now }

    factory :type_with_workflow, class: 'Type' do
      callback(:after_build) do |t|
        t.workflows = [FactoryBot.build(:workflow_with_default_status)]
      end
    end

    factory :type_with_relation_query_group, class: 'Type' do
      transient do
        relation_filter { 'parent' }
      end

      callback(:after_build) do |t, evaluator|
        query = FactoryBot.create(:query)
        query.add_filter(evaluator.relation_filter.to_s, '=', [::Queries::Filters::TemplatedValue::KEY])
        query.save
        t.attribute_groups = t.default_attribute_groups + [["Embedded table for #{evaluator.relation_filter}",
                                                            ["query_#{query.id}".to_sym]]]
      end
    end
  end

  factory :type_standard, class: '::Type' do
    name { 'None' }
    is_standard { true }
    is_default { true }
    created_at { Time.now }
    updated_at { Time.now }
  end

  factory :type_bug, class: '::Type' do
    name { 'Bug' }
    position { 1 }
    created_at { Time.now }
    updated_at { Time.now }

    # reuse existing type with the given name
    # this prevents a validation error (name has to be unique)
    initialize_with { ::Type.find_or_initialize_by(name: name) }

    factory :type_feature do
      name { 'Feature' }
      position { 2 }
      is_default { true }
    end

    factory :type_support do
      name { 'Support' }
      position { 3 }
    end

    factory :type_task do
      name { 'Task' }
      position { 4 }
    end
  end
end
