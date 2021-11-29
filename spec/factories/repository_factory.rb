

FactoryBot.define do
  factory :repository_subversion, class: 'Repository::Subversion' do
    url { 'file://tmp/svn_test_repo' }
    scm_type { 'existing' }
    project
  end

  factory :repository_git, class: 'Repository::Git' do
    url { 'file://tmp/git_test_repo' }
    scm_type { 'local' }
    path_encoding { 'UTF-8' }
    project
  end
end
