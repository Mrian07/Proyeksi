

require 'spec_helper'

describe 'Create repository', type: :feature, js: true do
  let(:current_user) { FactoryBot.create (:admin) }
  let(:project) { FactoryBot.create(:project) }
  let(:enabled_scms) { %w[git] }

  before do
    allow(User).to receive(:current).and_return current_user
    allow(Setting).to receive(:enabled_scm).and_return(enabled_scms)
    allow(Setting).to receive(:repository_checkout_data).and_return(checkout_data)

    allow(OpenProject::Configuration).to receive(:[]).and_call_original
    allow(OpenProject::Configuration).to receive(:[]).with('scm').and_return(config)
  end

  context 'managed repositories' do
    include_context 'with tmpdir'
    let(:config) do
      {
        git: { manages: File.join(tmpdir, 'git') }
      }
    end
    let(:checkout_data) do
      { 'git' => { 'enabled' => '1', 'base_url' => 'http://localhost/git/' } }
    end

    let!(:repository) do
      repo = FactoryBot.build(:repository_git, scm_type: :managed)
      repo.project = project
      repo.configure(:managed, nil)
      repo.save!
      perform_enqueued_jobs

      repo
    end

    it 'toggles checkout instructions' do
      visit project_repository_path(project)

      expect(page).to have_selector('#repository--checkout-instructions')

      button = find('#repository--checkout-instructions-toggle')
      button.click

      expect(page).not_to have_selector('#repository--checkout-instructions')
    end
  end
end
