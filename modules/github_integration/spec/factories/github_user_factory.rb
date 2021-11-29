

FactoryBot.define do
  factory :github_user do
    sequence(:github_id)
    sequence(:github_login) { |n| "user_#{n}" }
    github_html_url { "https://github.com/#{github_login}" }
    github_avatar_url { "https://github.com/#{github_login}_avatar.jpg" }
  end
end
