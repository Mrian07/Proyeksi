

require File.expand_path('../../../../spec_helper', __dir__)

describe ProyeksiApp::GithubIntegration::NotificationHandler::CheckRun do
  subject(:process) { described_class.new.process(payload) }

  let(:upsert_check_run_service) do
    instance_double(ProyeksiApp::GithubIntegration::Services::UpsertCheckRun)
  end
  let(:payload) do
    {
      'check_run' => {
        'pull_requests' => pull_requests_payload
      }
    }
  end
  let(:pull_requests_payload) { [] }

  before do
    allow(ProyeksiApp::GithubIntegration::Services::UpsertCheckRun).to receive(:new)
                                                                              .and_return(upsert_check_run_service)
    allow(upsert_check_run_service).to receive(:call).and_return(nil)
  end

  it 'does not call the UpsertCheckRun service when the check_run is not associated to a PR' do
    process
    expect(upsert_check_run_service).not_to have_received(:call)
  end

  context 'when the check_run is not associated to a known GithubPullRequest' do
    let(:pull_requests_payload) do
      [
        {
          'id' => 123
        }
      ]
    end

    it 'does not call the UpsertCheckRun service' do
      process
      expect(upsert_check_run_service).not_to have_received(:call)
    end
  end

  context 'when the check_run is associated to a known GithubPullRequest' do
    let(:pull_requests_payload) do
      [
        {
          'id' => 123
        }
      ]
    end
    let(:github_pull_request) { FactoryBot.create :github_pull_request, github_id: 123 }

    before { github_pull_request }

    it 'does not call the UpsertCheckRun service' do
      process
      expect(upsert_check_run_service).to have_received(:call).with(
        payload['check_run'],
        pull_request: github_pull_request
      )
    end
  end
end
