

require 'spec_helper'

describe ::API::V3::GithubPullRequests::GithubCheckRunRepresenter do
  include ::API::V3::Utilities::PathHelper

  subject(:generated) { representer.to_json }

  let(:check_run) { FactoryBot.build_stubbed(:github_check_run) }
  let(:representer) { described_class.create(check_run, current_user: user) }
  let(:user) { FactoryBot.build_stubbed(:admin) }

  it { is_expected.to include_json('GithubCheckRun'.to_json).at_path('_type') }

  describe 'properties' do
    it_behaves_like 'property', :_type do
      let(:value) { 'GithubCheckRun' }
    end

    it_behaves_like 'property', :htmlUrl do
      let(:value) { check_run.github_html_url }
    end

    it_behaves_like 'property', :appOwnerAvatarUrl do
      let(:value) { check_run.github_app_owner_avatar_url }
    end

    it_behaves_like 'property', :name do
      let(:value) { check_run.name }
    end

    it_behaves_like 'property', :status do
      let(:value) { check_run.status }
    end

    it_behaves_like 'property', :conclusion do
      let(:value) { check_run.conclusion }
    end

    it_behaves_like 'property', :outputTitle do
      let(:value) { check_run.output_title }
    end

    it_behaves_like 'property', :outputSummary do
      let(:value) { check_run.output_summary }
    end

    it_behaves_like 'property', :detailsUrl do
      let(:value) { check_run.details_url }
    end

    it_behaves_like 'has UTC ISO 8601 date and time' do
      let(:date) { check_run.started_at }
      let(:json_path) { 'startedAt' }
    end

    it_behaves_like 'has UTC ISO 8601 date and time' do
      let(:date) { check_run.completed_at }
      let(:json_path) { 'completedAt' }
    end
  end

  describe '_links' do
    it { is_expected.to have_json_type(Object).at_path('_links') }
    it { is_expected.to have_json_path('_links/self/href') }
  end

  describe 'caching' do
    before do
      allow(ProyeksiApp::Cache).to receive(:fetch).and_call_original
    end

    it "is based on the representer's cache_key" do
      representer.to_json

      expect(ProyeksiApp::Cache)
        .to have_received(:fetch)
        .with(representer.json_cache_key)
    end

    describe '#json_cache_key' do
      let!(:former_cache_key) { representer.json_cache_key }

      it 'includes the name of the representer class' do
        expect(representer.json_cache_key)
          .to include('API', 'V3', 'GithubPullRequests', 'GithubCheckRunRepresenter')
      end

      it 'changes when the locale changes' do
        I18n.with_locale(:fr) do
          expect(representer.json_cache_key)
            .not_to eql former_cache_key
        end
      end

      it 'changes when the check run is updated' do
        check_run.updated_at = Time.zone.now + 20.seconds

        expect(representer.json_cache_key)
          .not_to eql former_cache_key
      end
    end
  end
end
