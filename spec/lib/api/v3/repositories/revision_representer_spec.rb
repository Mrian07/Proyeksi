

require 'spec_helper'

describe ::API::V3::Repositories::RevisionRepresenter do
  include ::API::V3::Utilities::PathHelper

  let(:representer) { described_class.new(revision, current_user: double('current_user')) }

  let(:project) { FactoryBot.build :project }
  let(:repository) { FactoryBot.build :repository_subversion, project: project }
  let(:revision) do
    FactoryBot.build(:changeset,
                     id: 42,
                     revision: '1234',
                     repository: repository,
                     comments: commit_message,
                     committer: 'foo bar <foo@example.org>',
                     committed_on: DateTime.now)
  end

  let(:commit_message) { 'Some commit message' }

  context 'generation' do
    subject(:generated) { representer.to_json }

    it { is_expected.to be_json_eql('Revision'.to_json).at_path('_type') }

    describe 'revision' do
      it { is_expected.to have_json_path('id') }

      it_behaves_like 'API V3 formattable', 'message' do
        let(:format) { 'plain' }
        let(:raw) { revision.comments }
        let(:html) { '<p>' + revision.comments + '</p>' }
      end

      describe 'identifier' do
        it { is_expected.to have_json_path('identifier') }
        it { is_expected.to be_json_eql('1234'.to_json).at_path('identifier') }
      end

      describe 'formattedIdentifier' do
        before do
          allow(revision).to receive(:format_identifier).and_return('123')
        end
        it { is_expected.to have_json_path('formattedIdentifier') }
        it { is_expected.to be_json_eql('123'.to_json).at_path('formattedIdentifier') }
      end

      describe 'createdAt' do
        it_behaves_like 'has UTC ISO 8601 date and time' do
          let(:date) { revision.committed_on }
          let(:json_path) { 'createdAt' }
        end
      end

      describe 'authorName' do
        it { is_expected.to have_json_path('authorName') }
        it { is_expected.to be_json_eql('foo bar '.to_json).at_path('authorName') }
      end
    end

    context 'with referencing commit message' do
      let(:work_package) { FactoryBot.build_stubbed(:work_package, project: project) }
      let(:commit_message) { "Totally references ##{work_package.id}" }
      let(:html_reference) do
        id = work_package.id

        str = 'Totally references <a'
        str << " class=\"issue work_package preview-trigger\""
        str << " href=\"/work_packages/#{id}\">"
        str << "##{id}</a>"
      end

      before do
        allow(User).to receive(:current).and_return(FactoryBot.build_stubbed(:admin))
        allow(WorkPackage)
          .to receive_message_chain('includes.references.find_by')
          .and_return(work_package)
      end

      it_behaves_like 'API V3 formattable', 'message' do
        let(:format) { 'plain' }
        let(:raw) { revision.comments }
        let(:html) { '<p>' + html_reference + '</p>' }
      end
    end

    describe 'author' do
      context 'with no linked user' do
        it_behaves_like 'has no link' do
          let(:link) { 'author' }
        end
      end

      context 'with linked user as author' do
        let(:user) { FactoryBot.build(:user) }
        before do
          allow(revision).to receive(:user).and_return(user)
        end

        it_behaves_like 'has a titled link' do
          let(:link) { 'author' }
          let(:href) { api_v3_paths.user(user.id) }
          let(:title) { user.name }
        end
      end
    end

    describe 'showRevision' do
      it_behaves_like 'has an untitled link' do
        let(:link) { 'showRevision' }
        let(:href) { api_v3_paths.show_revision(project.identifier, revision.identifier) }
      end
    end
  end
end
