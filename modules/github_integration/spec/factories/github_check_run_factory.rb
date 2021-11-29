

FactoryBot.define do
  factory :github_check_run do
    github_pull_request

    sequence(:github_id)
    github_html_url { "https://github.com/check_runs/#{github_id}" }
    github_app_owner_avatar_url { "https://github.com/apps/#{github_id}/owner.jpg" }
    name { 'test' }
    app_id { 12345 }
    status { 'completed' }
    conclusion { 'success' }
    output_title { 'an output title' }
    output_summary { 'an output summary' }
    details_url { "https://github.com/check_runs/#{github_id}/details" }
    started_at { 1.hour.ago }
    completed_at { 1.minute.ago }
  end
end
