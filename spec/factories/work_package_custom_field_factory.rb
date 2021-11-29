

FactoryBot.define do
  factory :work_package_custom_field do
    transient do
      default_locales { nil }
    end

    sequence(:name) { |n| "Custom Field Nr. #{n}" }
    regexp { '' }
    is_required { false }
    min_length { false }
    default_value { '' }
    max_length { false }
    editable { true }
    possible_values { '' }
    visible { true }
    field_format { 'bool' }
    type { 'WorkPackageCustomField' }
  end
end
