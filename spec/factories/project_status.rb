# encoding: utf-8



FactoryBot.define do
  factory :project_status, class: 'Projects::Status' do
    project
    sequence(:explanation) { |n| "Status explanation #{n}" }
    code { Projects::Status.codes[:on_track] }
  end
end
