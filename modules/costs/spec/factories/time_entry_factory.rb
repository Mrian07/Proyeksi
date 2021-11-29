

FactoryBot.define do
  factory :time_entry do
    project
    user
    work_package
    spent_on { Date.today }
    activity factory: :time_entry_activity
    hours { 1.0 }
  end
end
