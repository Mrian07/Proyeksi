

FactoryBot.define do
  factory :github_pull_request do
    github_user

    sequence(:number)
    sequence(:github_id)
    state { 'open' }
    github_html_url { "https://github.com/test_user/test_repo/pull/#{number}" }

    labels { [] }
    github_updated_at { Time.current }
    sequence(:title) { |n| "Title of PR #{n}" }
    sequence(:body) { |n| "Body of PR #{n}" }
    sequence(:repository) { |n| "test_user/repo_#{n}" }

    draft { false }
    merged { false }
    merged_by { nil }
    merged_at { nil }

    comments_count { 1 }
    review_comments_count { 2 }
    additions_count { 3 }
    deletions_count { 4 }
    changed_files_count { 5 }

    trait :partial do
      github_user { nil }
      github_id { nil }
      labels { nil }
      github_updated_at { nil }
      title { nil }
      body { nil }
      draft { false }
      merged { false }
      merged_by { nil }
      merged_at { nil }
      comments_count { nil }
      review_comments_count { nil }
      additions_count { nil }
      deletions_count { nil }
      changed_files_count { nil }
    end

    trait :draft do
      draft { true }
    end

    trait :open

    trait :closed_unmerged do
      state { 'closed' }
    end

    trait :closed_merged do
      state { 'closed' }
      merged { true }
      merged_by { association :github_user }
      merged_at { Time.current }
    end
  end
end
