

FactoryBot.define do
  factory :work_package do
    transient do
      custom_values { nil }
    end

    priority
    project factory: :project_with_types
    status factory: :status
    sequence(:subject) { |n| "WorkPackage No. #{n}" }
    description { |i| "Description for '#{i.subject}'" }
    author factory: :user
    created_at { Time.now }
    updated_at { Time.now }

    callback(:after_build) do |work_package, evaluator|
      work_package.type = work_package.project.types.first unless work_package.type

      custom_values = evaluator.custom_values || {}

      if custom_values.is_a? Hash
        custom_values.each_pair do |custom_field_id, value|
          work_package.custom_values.build custom_field_id: custom_field_id, value: value
        end
      else
        custom_values.each { |cv| work_package.custom_values << cv }
      end
    end
  end

  factory :stubbed_work_package, class: WorkPackage do
    transient do
      custom_values { nil }
    end

    priority
    project { FactoryBot.build_stubbed(:project_with_types) }
    status
    sequence(:subject) { |n| "WorkPackage No. #{n}" }
    description { |i| "Description for '#{i.subject}'" }
    author factory: :user
    created_at { Time.now }
    updated_at { Time.now }

    callback(:after_stub) do |wp, arguments|
      wp.type = wp.project.types.first unless wp.type_id || arguments.instance_variable_get(:@overrides).has_key?(:type)
    end
  end
end
