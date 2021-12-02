

require 'spec_helper'

describe ::API::V3::GithubPullRequests::GithubUserRepresenter do
  include ::API::V3::Utilities::PathHelper

  subject(:generated) { representer.to_json }

  let(:github_user) { FactoryBot.build_stubbed(:github_user) }
  let(:representer) { described_class.create(github_user, current_user: user) }

  let(:user) { FactoryBot.build_stubbed(:admin) }

  it { is_expected.to include_json('GithubUser'.to_json).at_path('_type') }

  describe 'properties' do
    it_behaves_like 'property', :_type do
      let(:value) { 'GithubUser' }
    end

    it_behaves_like 'property', :login do
      let(:value) { github_user.github_login }
    end

    it_behaves_like 'property', :htmlUrl do
      let(:value) { github_user.github_html_url }
    end

    it_behaves_like 'property', :avatarUrl do
      let(:value) { github_user.github_avatar_url }
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
          .to include('API', 'V3', 'GithubPullRequests', 'GithubUserRepresenter')
      end

      it 'changes when the locale changes' do
        I18n.with_locale(:fr) do
          expect(representer.json_cache_key)
            .not_to eql former_cache_key
        end
      end

      it 'changes when the github_user is updated' do
        github_user.updated_at = Time.zone.now + 20.seconds

        expect(representer.json_cache_key)
          .not_to eql former_cache_key
      end
    end
  end
end
