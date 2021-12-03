

require 'spec_helper'
require 'features/repositories/repository_settings_page'
require 'features/support/components/danger_zone'

describe 'Repository Settings', type: :feature, js: true do
  let(:current_user) { FactoryBot.create (:admin) }
  let(:project) { FactoryBot.create(:project) }
  let(:settings_page) { RepositorySettingsPage.new(project) }
  let(:dangerzone) { DangerZone.new(page) }

  # Allow to override configuration values to determine
  # whether to activate managed repositories
  let(:enabled_scms) { %w[subversion git] }
  let(:config) { nil }

  before do
    allow(User).to receive(:current).and_return current_user
    allow(Setting).to receive(:enabled_scm).and_return(enabled_scms)

    allow(ProyeksiApp::Configuration).to receive(:[]).and_call_original
    allow(ProyeksiApp::Configuration).to receive(:[]).with('scm').and_return(config)

    allow(project).to receive(:repository).and_return(repository)
    settings_page.visit_repository_settings
  end

  shared_examples 'manages the repository' do |type|
    it 'displays the repository' do
      expect(page).to have_selector('select[name="scm_vendor"]')
      expect(find("#attributes-group--content-#{type}", visible: true))
        .not_to be_nil
    end

    it 'deletes the repository' do
      expect(Repository.exists?(repository.id)).to be true

      if type == 'managed'
        SeleniumHubWaiter.wait
        find('a.icon-delete', text: I18n.t(:button_delete)).click

        dangerzone = DangerZone.new(page)

        expect(page).to have_selector(dangerzone.container_selector)
        expect(dangerzone.disabled?).to be true

        SeleniumHubWaiter.wait
        dangerzone.confirm_with('definitely not the correct value')
        expect(dangerzone.disabled?).to be true

        SeleniumHubWaiter.wait
        dangerzone.confirm_with(project.identifier)
        expect(dangerzone.disabled?).to be false

        SeleniumHubWaiter.wait
        dangerzone.danger_button.click
      else
        SeleniumHubWaiter.wait
        find('a.icon-remove', text: I18n.t(:button_remove)).click
        expect(page).to have_selector('.op-toast.-warning')
        SeleniumHubWaiter.wait
        find('a', text: I18n.t(:button_remove)).click
      end

      vendor = find('select[name="scm_vendor"]')
      expect(vendor).not_to be_nil
      expect(vendor.value).to be_empty

      selected = vendor.find('option[selected]')
      expect(selected.text).to eq('--- Please select ---')
      expect(selected[:disabled]).to be_truthy
      expect(selected[:selected]).to be_truthy

      # Project should have no repository
      expect(Repository.exists?(repository.id)).to be false
    end
  end

  shared_examples 'manages the repository with' do |name, type, _repository_type, _project_name|
    let(:repository) do
      FactoryBot.create("repository_#{name}".to_sym,
                        scm_type: type,
                        project: project)
    end
    it_behaves_like 'manages the repository', type
  end

  it_behaves_like 'manages the repository with', 'subversion', 'existing', 'Subversion - Repository', 'project'
  it_behaves_like 'manages the repository with', 'git', 'local', 'Git - Repository', 'project'

  context 'managed repositories' do
    context 'local' do
      include_context 'with tmpdir'
      let(:config) do
        {
          subversion: { manages: File.join(tmpdir, 'svn') },
          git: { manages: File.join(tmpdir, 'git') }
        }
      end

      let(:repository) do
        repo = Repository.build(
          project,
          managed_vendor,
          # Need to pass AC params here manually to simulate a regular repository build
          ActionController::Parameters.new({}),
          :managed
        )

        repo.save!
        repo
      end

      context 'Subversion' do
        let(:managed_vendor) { :subversion }
        it_behaves_like 'manages the repository', 'managed'
      end

      context 'Git' do
        let(:managed_vendor) { :git }
        it_behaves_like 'manages the repository', 'managed'
      end
    end

    context 'remote', webmock: true do
      let(:url) { 'http://myreposerver.example.com/api/' }
      let(:config) do
        {
          git: { manages: url }
        }
      end
      let(:managed_vendor) { :git }
      let(:repository) do
        repo = Repository.build(
          project,
          managed_vendor,
          # Need to pass AC params here manually to simulate a regular repository build
          ActionController::Parameters.new({}),
          :managed
        )

        stub_request(:post, url)
          .to_return(status: 200,
                     body: { success: true, url: 'file:///foo/bar' }.to_json)

        repo.save!
        repo
      end
      it_behaves_like 'manages the repository', 'managed'
    end
  end

  describe 'update repositories' do
    let(:repository) do
      FactoryBot.create(:repository_subversion,
                        scm_type: :existing,
                        project: project)
    end

    it 'can set login and password' do
      fill_in('repository[login]', with: 'foobar')
      fill_in('repository-password-placeholder', with: 'password')

      click_button(I18n.t(:button_save))
      expect(page).to have_selector('[name="repository[login]"][value="foobar"]')
      expect(page).to have_selector('.flash',
                                    text: I18n.t('repositories.update_settings_successful'))
    end
  end
end
