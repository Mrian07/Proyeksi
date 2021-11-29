

FactoryBot.define do
  factory :default_enumeration, class: 'Enumeration' do
    initialize_with do
      Enumeration.where(type: 'Enumeration', is_default: true).first || Enumeration.new
    end

    active { true }
    is_default { true }
    type { 'Enumeration' }
    name { 'Default Enumeration' }
  end

  factory :activity, class: 'TimeEntryActivity' do
    sequence(:name) { |i| "Activity #{i}" }
    active { true }
    is_default { false }

    factory :inactive_activity do
      active { false }
    end
    factory :default_activity do
      is_default { true }
    end
  end

  factory :priority, class: 'IssuePriority' do
    sequence(:name) { |i| "Priority #{i}" }
    active { true }

    factory :priority_low do
      name { 'Low' }

      # reuse existing priority with the given name
      # this prevents a validation error (name has to be unique)
      initialize_with { IssuePriority.find_or_create_by(name: name) }

      factory :priority_normal do
        name { 'Normal' }
      end

      factory :priority_high do
        name { 'High' }
      end

      factory :priority_urgent do
        name { 'Urgent' }
      end

      factory :priority_immediate do
        name { 'Immediate' }
      end
    end
  end
end
