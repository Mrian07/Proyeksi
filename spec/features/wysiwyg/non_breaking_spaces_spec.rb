

require 'spec_helper'

describe 'Wysiwyg &nbsp; behavior',
         type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:user) { admin }

  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[wiki]) }
  let(:editor) { ::Components::WysiwygEditor.new }

  before do
    login_as(user)
  end

  describe 'in wikis' do
    describe 'creating a wiki page' do
      before do
        visit project_wiki_path(project, :wiki)
      end

      it 'can insert strong formatting with nbsp' do
        editor.click_and_type_slowly 'some text ', [:control, 'b'], 'with bold'

        # Save wiki page
        click_on 'Save'

        expect(page).to have_selector('.flash.notice')

        within('#content') do
          expect(page).to have_selector('p', text: 'some text with bold')
          expect(page).to have_selector('strong', text: 'with bold')
        end
      end
    end
  end
end
