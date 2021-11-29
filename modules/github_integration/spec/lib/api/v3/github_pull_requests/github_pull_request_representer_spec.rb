

require 'spec_helper'

describe ::API::V3::GithubPullRequests::GithubPullRequestRepresenter do
  include ::API::V3::Utilities::PathHelper

  subject(:generated) { representer.to_json }

  let(:github_pull_request) do
    FactoryBot.build_stubbed(:github_pull_request,
                             state: 'open',
                             labels: labels,
                             github_user: github_user,
                             merged_by: merged_by).tap do |pr|
      allow(pr)
        .to receive(:latest_check_runs)
        .and_return(latest_check_runs)
    end
  end
  let(:labels) do
    [
      {
        'name' => 'grey',
        'color' => '#666'
      }
    ]
  end
  let(:github_user) { FactoryBot.build_stubbed(:github_user) }
  let(:merged_by) { FactoryBot.build_stubbed(:github_user) }
  let(:latest_check_runs) { [check_run] }
  let(:check_run) { FactoryBot.build_stubbed(:github_check_run) }
  let(:representer) { described_class.create(github_pull_request, current_user: user) }

  let(:user) { FactoryBot.build_stubbed(:admin) }

  it { is_expected.to include_json('GithubPullRequest'.to_json).at_path('_type') }

  describe 'properties' do
    it_behaves_like 'property', :_type do
      let(:value) { 'GithubPullRequest' }
    end

    it_behaves_like 'property', :id do
      let(:value) { github_pull_request.id }
    end

    it_behaves_like 'property', :number do
      let(:value) { github_pull_request.number }
    end

    it_behaves_like 'property', :htmlUrl do
      let(:value) { github_pull_request.github_html_url }
    end

    it_behaves_like 'property', :state do
      let(:value) { github_pull_request.state }
    end

    it_behaves_like 'property', :repository do
      let(:value) { github_pull_request.repository }
    end

    it_behaves_like 'property', :title do
      let(:value) { github_pull_request.title }
    end

    it_behaves_like 'formattable property', :body do
      let(:value) { github_pull_request.body }
    end

    it_behaves_like 'property', :draft do
      let(:value) { github_pull_request.draft }
    end

    it_behaves_like 'property', :merged do
      let(:value) { github_pull_request.merged }
    end

    it_behaves_like 'property', :commentsCount do
      let(:value) { github_pull_request.comments_count }
    end

    it_behaves_like 'property', :reviewCommentsCount do
      let(:value) { github_pull_request.review_comments_count }
    end

    it_behaves_like 'property', :additionsCount do
      let(:value) { github_pull_request.additions_count }
    end

    it_behaves_like 'property', :deletionsCount do
      let(:value) { github_pull_request.deletions_count }
    end

    it_behaves_like 'property', :changedFilesCount do
      let(:value) { github_pull_request.changed_files_count }
    end

    it_behaves_like 'property', :labels do
      let(:value) { github_pull_request.labels }
    end

    it_behaves_like 'has UTC ISO 8601 date and time' do
      let(:date) { github_pull_request.github_updated_at }
      let(:json_path) { 'githubUpdatedAt' }
    end

    it_behaves_like 'has UTC ISO 8601 date and time' do
      let(:date) { github_pull_request.created_at }
      let(:json_path) { 'createdAt' }
    end

    it_behaves_like 'has UTC ISO 8601 date and time' do
      let(:date) { github_pull_request.updated_at }
      let(:json_path) { 'updatedAt' }
    end
  end

  describe '_links' do
    it { is_expected.to have_json_type(Object).at_path('_links') }

    it_behaves_like 'has a titled link' do
      let(:link) { 'githubUser' }
      let(:href) { api_v3_paths.github_user(github_user.id) }
      let(:title) { github_user.github_login }
    end

    it_behaves_like 'has a titled link' do
      let(:link) { 'mergedBy' }
      let(:href) { api_v3_paths.github_user(merged_by.id) }
      let(:title) { merged_by.github_login }
    end

    it_behaves_like 'has a link collection' do
      let(:link) { 'checkRuns' }
      let(:hrefs) do
        [
          {
            'href' => api_v3_paths.github_check_run(check_run.id),
            'title' => check_run.name
          }
        ]
      end
    end
  end

  describe 'caching' do
    before do
      allow(OpenProject::Cache).to receive(:fetch).and_call_original
    end

    it "is based on the representer's cache_key" do
      representer.to_json

      expect(OpenProject::Cache)
        .to have_received(:fetch)
        .with(representer.json_cache_key)
    end

    describe '#json_cache_key' do
      let!(:former_cache_key) { representer.json_cache_key }

      it 'includes the name of the representer class' do
        expect(representer.json_cache_key)
          .to include('API', 'V3', 'GithubPullRequests', 'GithubPullRequestRepresenter')
      end

      it 'changes when the locale changes' do
        I18n.with_locale(:fr) do
          expect(representer.json_cache_key)
            .not_to eql former_cache_key
        end
      end

      it 'changes when the github_pull_request is updated' do
        github_pull_request.updated_at = Time.zone.now + 20.seconds

        expect(representer.json_cache_key)
          .not_to eql former_cache_key
      end

      it 'changes when the github_user is updated' do
        github_pull_request.github_user.updated_at = Time.zone.now + 20.seconds

        expect(representer.json_cache_key)
          .not_to eql former_cache_key
      end

      it 'changes when the merged_by user is updated' do
        github_pull_request.merged_by.updated_at = Time.zone.now + 20.seconds

        expect(representer.json_cache_key)
          .not_to eql former_cache_key
      end
    end
  end
end
