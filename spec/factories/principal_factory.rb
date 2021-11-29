

FactoryBot.define do
  factory :principal do
    transient do
      member_in_project { nil }
      member_in_projects { nil }
      member_through_role { nil }
      member_with_permissions { nil }

      global_role { nil }
      global_permission { nil }
    end

    # necessary as we have created_on instead of created_at for which factory girl would
    # provide values automatically
    created_at { Time.now }
    updated_at { Time.now }

    callback(:after_build) do |principal, evaluator|
      is_build_strategy = evaluator.instance_eval { @build_strategy.is_a? FactoryBot::Strategy::Build }
      uses_member_association = evaluator.member_in_project || evaluator.member_in_projects
      if is_build_strategy && uses_member_association
        raise ArgumentError, "Use FactoryBot.create(...) with principals and member_in_project(s) traits."
      end
    end

    callback(:after_create) do |principal, evaluator|
      (projects = evaluator.member_in_projects || [])
      projects << evaluator.member_in_project if evaluator.member_in_project
      if projects.any?
        role = evaluator.member_through_role || FactoryBot.build(:role,
                                                                 permissions: evaluator.member_with_permissions || %i[
                                                                   view_work_packages edit_work_packages
                                                                 ])
        projects.compact.each do |project|
          FactoryBot.create(:member,
                            project: project,
                            principal: principal,
                            roles: Array(role))
        end
      end
    end

    callback(:after_create) do |principal, evaluator|
      if evaluator.global_permission || evaluator.global_role
        permissions = Array(evaluator.global_permission)
        global_role = evaluator.global_role || FactoryBot.create(:global_role, permissions: permissions)

        FactoryBot.create(:global_member,
                          principal: principal,
                          roles: [global_role])

      end
    end
  end
end
