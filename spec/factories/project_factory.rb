# encoding: utf-8



FactoryBot.define do
  factory :project do
    transient do
      no_types { false }
      disable_modules { [] }
      members { [] }
    end

    sequence(:name) { |n| "My Project No. #{n}" }
    sequence(:identifier) { |n| "myproject_no_#{n}" }
    created_at { Time.now }
    updated_at { Time.now }
    enabled_module_names { ProyeksiApp::AccessControl.available_project_modules }
    public { false }
    templated { false }

    callback(:after_build) do |project, evaluator|
      disabled_modules = Array(evaluator.disable_modules)
      project.enabled_module_names = project.enabled_module_names - disabled_modules

      if !evaluator.no_types && project.types.empty?
        project.types << (::Type.where(is_standard: true).first || FactoryBot.build(:type_standard))
      end
    end

    callback(:after_create) do |project, evaluator|
      evaluator.members.each do |user, roles|
        Members::CreateService
          .new(user: User.system, contract_class: EmptyContract)
          .call(principal: user, project: project, roles: Array(roles))
      end
    end

    factory :public_project do
      public { true } # Remark: public defaults to true
    end

    factory :template_project do
      sequence(:name) { |n| "Template project No. #{n}" }
      sequence(:identifier) { |n| "template_no_#{n}" }
      templated { true }
    end

    factory :project_with_types do
      # using initialize_with types to prevent
      # the project's initialize function looking for the default type
      # when we will be setting the type later on anyway
      initialize_with do
        types = if instance_variable_get(:@build_strategy).is_a?(FactoryBot::Strategy::Stub)
                  [FactoryBot.build_stubbed(:type)]
                else
                  [FactoryBot.build(:type)]
                end

        new(types: types)
      end

      factory :valid_project do
        callback(:after_build) do |project|
          project.types << FactoryBot.build(:type_with_workflow)
        end
      end
    end
  end
end
