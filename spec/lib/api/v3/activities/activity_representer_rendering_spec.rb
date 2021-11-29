

require 'spec_helper'

describe ::API::V3::Activities::ActivityRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.build_stubbed(:user).tap do |u|
      allow(u)
        .to receive(:allowed_to?) do |checked_permission, project|
        project == work_package.project && permissions.include?(checked_permission)
      end
    end
  end
  let(:other_user) { FactoryBot.build_stubbed(:user) }
  let(:work_package) { journal.journable }
  let(:notes) { "My notes" }
  let(:journal) do
    FactoryBot.build_stubbed(:work_package_journal, notes: notes, user: other_user).tap do |journal|
      allow(journal)
        .to receive(:get_changes)
        .and_return(changes)
    end
  end
  let(:changes) { { subject: ["first subject", "second subject"] } }
  let(:permissions) { %i(edit_work_package_notes) }
  let(:representer) { described_class.new(journal, current_user: current_user) }

  before do
    login_as(current_user)
  end

  subject(:generated) { representer.to_json }

  describe 'properties' do
    describe 'type' do
      context 'with notes' do
        let(:notes) { 'Some notes' }

        it_behaves_like 'property', :_type do
          let(:value) { 'Activity::Comment' }
        end
      end

      context 'with empty notes' do
        let(:notes) { '' }

        it_behaves_like 'property', :_type do
          let(:value) { 'Activity' }
        end
      end

      context 'with empty notes and empty changes' do
        let(:notes) { '' }
        let(:changes) { {} }

        it_behaves_like 'property', :_type do
          let(:value) { 'Activity::Comment' }
        end
      end
    end

    describe 'id' do
      it_behaves_like 'property', :id do
        let(:value) { journal.id }
      end
    end

    describe 'createdAt' do
      it_behaves_like 'has UTC ISO 8601 date and time' do
        let(:date) { journal.created_at }
        let(:json_path) { 'createdAt' }
      end
    end

    describe 'version' do
      it_behaves_like 'property', :version do
        let(:value) { journal.version }
      end
    end

    describe 'comment' do
      it_behaves_like 'API V3 formattable', 'comment' do
        let(:format) { 'markdown' }
        let(:raw) { journal.notes }
        let(:html) { "<p class=\"op-uc-p\">#{journal.notes}</p>" }
      end

      context 'if having no change and notes' do
        let(:notes) { "" }
        let(:changes) { {} }

        it_behaves_like 'API V3 formattable', 'comment' do
          let(:format) { 'markdown' }
          let(:raw) { "_#{I18n.t(:'journals.changes_retracted')}_" }
          let(:html) { "<p class=\"op-uc-p\"><em>#{I18n.t(:'journals.changes_retracted')}</em></p>" }
        end
      end
    end

    describe 'details' do
      it { is_expected.to have_json_path('details') }

      it { is_expected.to have_json_size(journal.details.count).at_path('details') }

      it 'renders all details as formattable' do
        (0..journal.details.count - 1).each do |x|
          is_expected.to be_json_eql('custom'.to_json).at_path("details/#{x}/format")
          is_expected.to have_json_path("details/#{x}/raw")
          is_expected.to have_json_path("details/#{x}/html")
        end
      end
    end
  end

  describe '_links' do
    describe 'self' do
      it_behaves_like 'has an untitled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.activity journal.id }
      end
    end

    describe 'workPackage' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'workPackage' }
        let(:href) { api_v3_paths.work_package work_package.id }
        let(:title) { work_package.subject }
      end
    end

    describe 'user' do
      it_behaves_like 'has an untitled link' do
        let(:link) { 'user' }
        let(:href) { api_v3_paths.user other_user.id }
      end
    end

    describe 'update' do
      let(:link) { 'update' }
      let(:href) { api_v3_paths.activity(journal.id) }

      it_behaves_like 'has an untitled link'

      context 'with a non own journal having edit_work_package_notes permission' do
        it_behaves_like 'has an untitled link'
      end

      context 'with a non own journal having only edit_own work_package_notes permission' do
        let(:permissions) { %i(edit_own_work_package_notes) }

        it_behaves_like 'has no link'
      end
    end
  end
end
