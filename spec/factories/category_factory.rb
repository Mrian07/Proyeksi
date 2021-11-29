

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Issue category #{n}" }
    project

    callback(:after_build) do |issue|
      issue.assigned_to = issue.project.users.first unless issue.assigned_to
    end
  end
end
