

FactoryBot.define do
  factory :group, parent: :principal, class: 'Group' do
    # groups have lastnames? hmm...
    sequence(:lastname) { |g| "Group #{g}" }

    transient do
      members { [] }
    end

    callback(:after_create) do |group, evaluator|
      members = Array(evaluator.members)
      next if members.empty?

      User.system.run_given do |system_user|
        ::Groups::AddUsersService
          .new(group, current_user: system_user)
          .call(ids: members.map(&:id))
          .on_failure { |call| raise call.message }
      end
    end
  end
end
