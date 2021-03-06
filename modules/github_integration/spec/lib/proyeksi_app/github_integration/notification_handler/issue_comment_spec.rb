

require File.expand_path('../../../../spec_helper', __dir__)

describe ProyeksiApp::GithubIntegration::NotificationHandler::IssueComment do
  subject(:process) { handler_instance.process(payload) }

  let(:handler_instance) { described_class.new }
  let(:upsert_partial_pull_request_service) do
    instance_double(ProyeksiApp::GithubIntegration::Services::UpsertPartialPullRequest)
  end
  let(:payload) do
    {
      'action' => action,
      'comment' => {
        'body' => comment_body,
        'html_url' => 'https://comment.url',
        'user' => {
          'login' => 'test_user',
          'html_url' => 'https://github.com/test_user'
        }
      },
      'issue' => {
        'number' => pr_number,
        'title' => 'PR or issue title',
        'pull_request' => pr_payload
      },
      'repository' => {
        'full_name' => repo_full_name,
        'html_url' => 'https://github.com/test_user/repo'
      },
      'proyeksi_app_user_id' => github_system_user.id
    }
  end
  let(:comment_body) { "a comment about OP##{work_package.id}" }
  let(:pr_payload) { { 'html_url' => pr_html_url } }
  let(:pr_html_url) { 'https://github.com/test_user/repo/pull/123' }
  let(:pr_number) { 123 }
  let(:repo_full_name) { 'test_user/repo' }
  let(:github_system_user) { FactoryBot.create :admin }
  let(:work_package) { FactoryBot.create :work_package }

  before do
    allow(handler_instance)
      .to receive(:comment_on_referenced_work_packages)
            .and_return(nil)
    allow(ProyeksiApp::GithubIntegration::Services::UpsertPartialPullRequest)
      .to receive(:new)
            .and_return(upsert_partial_pull_request_service)
    allow(upsert_partial_pull_request_service)
      .to receive(:call)
            .and_return(nil)
  end

  shared_examples_for 'upserting a GithubPullRequest' do
    it 'calls the UpsertPartialPullRequest service' do
      process
      expect(upsert_partial_pull_request_service)
        .to have_received(:call) do |received_payload, work_packages:|
        expect(received_payload.to_h)
          .to eql payload
        expect(work_packages)
          .to match_array [work_package]
      end
    end
  end

  shared_examples_for 'not upserting a GithubPullRequest' do
    it 'does not call the UpsertPartialPullRequest service' do
      process
      expect(upsert_partial_pull_request_service).not_to have_received(:call)
    end
  end

  shared_examples_for 'creating a comment on the work package' do
    it 'adds a comment to work packages' do
      process
      expect(handler_instance).to have_received(:comment_on_referenced_work_packages).with([work_package], github_system_user,
                                                                                           comment)
    end
  end

  shared_examples_for 'not creating comments on work packages' do
    it 'does not add comments to work packages' do
      process
      expect(handler_instance).not_to have_received(:comment_on_referenced_work_packages)
    end
  end

  context 'when a comment was created' do
    let(:action) { 'created' }

    context 'when commented on an issue' do
      let(:pr_payload) { nil }

      it_behaves_like 'not creating comments on work packages'
      it_behaves_like 'not upserting a GithubPullRequest'
    end

    context 'when commented on a PR' do
      let(:comment) do
        "**Referenced in PR:** [test_user](https://github.com/test_user) referenced this work package" \
        " in Pull request 123 [PR or issue title](https://comment.url) on [test_user/repo](https://github.com/test_user/repo).\n"
      end

      it_behaves_like 'creating a comment on the work package'
      it_behaves_like 'upserting a GithubPullRequest'
    end

    context 'when we already have a GithubPullRequest for the commented PR' do
      let(:github_pull_request) { FactoryBot.create(:github_pull_request, github_html_url: pr_html_url) }
      let(:comment) do
        "**Referenced in PR:** [test_user](https://github.com/test_user) referenced this work package" \
        " in Pull request 123 [PR or issue title](https://comment.url) on [test_user/repo](https://github.com/test_user/repo).\n"
      end

      before do
        github_pull_request
      end

      it_behaves_like 'creating a comment on the work package'
      it_behaves_like 'upserting a GithubPullRequest'
    end

    context 'when we already have a GithubPullRequest with that work_package' do
      let(:github_pull_request) do
        FactoryBot.create(:github_pull_request, github_html_url: pr_html_url, work_packages: [work_package])
      end

      before do
        github_pull_request
      end

      it_behaves_like 'not creating comments on work packages'

      it 'calls the UpsertPartialPullRequest service without adding already known work_packages' do
        process
        expect(upsert_partial_pull_request_service)
          .to have_received(:call) do |received_payload, work_packages:|
          expect(received_payload.to_h)
            .to eql payload
          expect(work_packages)
            .to match_array []
        end
      end
    end
  end

  context 'when a comment was edited' do
    let(:action) { 'edited' }

    context 'when editing an issue comment' do
      let(:pr_payload) { nil }

      it_behaves_like 'not creating comments on work packages'
      it_behaves_like 'not upserting a GithubPullRequest'
    end

    context 'when editing a PR comment with a new work package reference' do
      let(:comment) do
        "**Referenced in PR:** [test_user](https://github.com/test_user) referenced this work package" \
        " in Pull request 123 [PR or issue title](https://comment.url) on [test_user/repo](https://github.com/test_user/repo).\n"
      end

      it_behaves_like 'creating a comment on the work package'
      it_behaves_like 'upserting a GithubPullRequest'
    end

    context 'when we already have a GithubPullRequest for the commented PR' do
      let(:github_pull_request) { FactoryBot.create(:github_pull_request, github_html_url: pr_html_url) }
      let(:comment) do
        "**Referenced in PR:** [test_user](https://github.com/test_user) referenced this work package" \
        " in Pull request 123 [PR or issue title](https://comment.url) on [test_user/repo](https://github.com/test_user/repo).\n"
      end

      before do
        github_pull_request
      end

      it_behaves_like 'creating a comment on the work package'
      it_behaves_like 'upserting a GithubPullRequest'
    end

    context 'when we already have a GithubPullRequest with that work_package' do
      let(:github_pull_request) do
        FactoryBot.create(:github_pull_request, github_html_url: pr_html_url, work_packages: [work_package])
      end

      before do
        github_pull_request
      end

      it_behaves_like 'not creating comments on work packages'

      it 'calls the UpsertPartialPullRequest service without adding already known work_packages' do
        process
        expect(upsert_partial_pull_request_service)
          .to have_received(:call) do |received_payload, work_packages:|
          expect(received_payload.to_h)
            .to eql payload
          expect(work_packages)
            .to match_array []
        end
      end
    end
  end
end
