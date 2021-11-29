

require 'spec_helper'

describe ::API::V3::Versions::VersionCollectionRepresenter do
  let(:self_link) { '/api/v3/projects/1/versions' }
  let(:versions) { FactoryBot.build_stubbed_list(:version, 3) }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:representer) { described_class.new(versions, self_link: self_link, current_user: user) }

  include API::V3::Utilities::PathHelper

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'unpaginated APIv3 collection', 3, 'projects/1/versions', 'Version'

    context '_links' do
      before do
        allow(user)
          .to receive(:allowed_to_globally?)
          .and_return(false)

        allow(user)
          .to receive(:allowed_to_globally?)
          .with(:manage_versions)
          .and_return(allowed_to)
      end

      describe 'createVersionImmediately' do
        context 'if the user is allowed to' do
          let(:allowed_to) { true }

          it_behaves_like 'has an untitled link' do
            let(:link) { 'createVersionImmediately' }
            let(:href) { api_v3_paths.versions }
          end
        end

        context 'if the user is not allowed to' do
          let(:allowed_to) { false }

          it_behaves_like 'has no link' do
            let(:link) { 'createVersionImmediately' }
          end
        end
      end

      describe 'createVersion' do
        context 'if the user is allowed to' do
          let(:allowed_to) { true }

          it_behaves_like 'has an untitled link' do
            let(:link) { 'createVersion' }
            let(:href) { api_v3_paths.create_version_form }
          end
        end

        context 'if the user is not allowed to' do
          let(:allowed_to) { false }

          it_behaves_like 'has no link' do
            let(:link) { 'createVersion' }
          end
        end
      end
    end
  end
end
