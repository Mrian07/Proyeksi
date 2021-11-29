

require 'spec_helper'

describe 'Wysiwyg linking',
         type: :feature, js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[wiki work_package_tracking]) }
  let(:editor) { ::Components::WysiwygEditor.new }

  before do
    login_as(user)
  end

  describe 'creating a wiki page' do
    before do
      visit project_wiki_path(project, :wiki)
    end

    it 'can create links with spaces (Regression #29742)' do
      # single hash autocomplete
      editor.insert_link 'http://example.org/link with spaces'

      # Save wiki page
      click_on 'Save'

      expect(page).to have_selector('.flash.notice')

      wiki_page = project.wiki.pages.first.reload

      expect(wiki_page.content.text).to eq(
        "[http://example.org/link with spaces](http://example.org/link%20with%20spaces)"
      )

      expect(page).to have_selector('a[href="http://example.org/link%20with%20spaces"]')
    end
  end
end
