

FactoryBot.define do
  factory :cost_entry do
    project
    user
    work_package
    cost_type
    spent_on { Date.today }
    units { 1 }
    comments { '' }

    before(:create) do |ce|
      ce.work_package.project = ce.project

      unless ce.project.users.include?(ce.user)
        Members::CreateService
          .new(user: User.system, contract_class: EmptyContract)
          .call(principal: ce.user,
                project: ce.project,
                roles: [FactoryBot.create(:role)])
      end
    end
  end
end
