

require File.expand_path('../../../../spec_helper', __dir__)

describe OpenProject::GithubIntegration::Services::UpsertCheckRun do
  subject(:upsert) { described_class.new.call(params, pull_request: github_pull_request) }

  let(:github_pull_request) { FactoryBot.create :github_pull_request }
  let(:params) do
    {
      'id' => 123,
      'html_url' => 'https://github.com/check_runs/123',
      'name' => 'test',
      'status' => 'completed',
      'conclusion' => 'success',
      'details_url' => 'https://github.com/details',
      'started_at' => 1.hour.ago.iso8601,
      'completed_at' => 1.minute.ago.iso8601,
      'output' => {
        'title' => 'a title',
        'summary' => 'a summary'
      },
      'app' => {
        'id' => 456,
        'owner' => {
          'avatar_url' => 'https:://github.com/apps/456/avatar.png'
        }
      }
    }
  end

  it 'creates a new check run for the given pull request' do
    expect { upsert }.to change(GithubCheckRun, :count).by(1)

    expect(GithubCheckRun.last).to have_attributes(
      github_id: 123,
      github_html_url: 'https://github.com/check_runs/123',
      app_id: 456,
      github_app_owner_avatar_url: 'https:://github.com/apps/456/avatar.png',
      name: 'test',
      status: 'completed',
      conclusion: 'success',
      output_title: 'a title',
      output_summary: 'a summary',
      details_url: 'https://github.com/details',
      github_pull_request: github_pull_request
    )
  end

  context 'when a check run with that id already exists' do
    let(:check_run) { FactoryBot.create(:github_check_run, github_id: 123, status: 'queued') }

    it 'updates the check run' do
      expect { upsert }.to change { check_run.reload.status }.from('queued').to('completed')
    end
  end
end
