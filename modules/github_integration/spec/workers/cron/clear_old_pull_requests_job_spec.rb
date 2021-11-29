#-- encoding: UTF-8



require 'spec_helper'

describe Cron::ClearOldPullRequestsJob, type: :job do
  let(:pull_request_without_work_package) do
    FactoryBot.create(:github_pull_request, work_packages: [])
  end
  let(:pull_request_with_work_package) { FactoryBot.create(:github_pull_request, work_packages: [work_package]) }
  let(:work_package) { FactoryBot.create(:work_package) }
  let(:check_run) { FactoryBot.create(:github_check_run, github_pull_request: pull_request_without_work_package) }

  let(:job) { described_class.new }

  before do
    pull_request_without_work_package
    check_run
    pull_request_with_work_package
  end

  it 'removes pull request without work packages attached' do
    expect { job.perform }.to change(GithubPullRequest, :count).by(-1).and(change(GithubCheckRun, :count).by(-1))

    expect(GithubPullRequest.all)
      .to match_array([pull_request_with_work_package])
  end
end
