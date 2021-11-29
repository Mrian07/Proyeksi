

require 'spec_helper'

describe 'Wysiwyg work package linking',
         type: :feature, js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[wiki work_package_tracking]) }
  let(:work_package) { FactoryBot.create(:work_package, subject: 'Foobar', project: project) }
  let(:editor) { ::Components::WysiwygEditor.new }

  before do
    login_as(user)
  end

  describe 'creating a wiki page' do
    before do
      visit project_wiki_path(project, :wiki)
    end

    it 'can reference work packages' do
      # single hash autocomplete
      editor.click_and_type_slowly "##{work_package.id}"
      editor.click_autocomplete work_package.subject

      expect(editor.editor_element).to have_selector('a.mention', text: "##{work_package.id}")

      # Save wiki page
      click_on 'Save'

      expect(page).to have_selector('.flash.notice')

      within('#content') do
        expect(page).to have_selector('a.issue', count: 1)
      end
    end
  end
end
