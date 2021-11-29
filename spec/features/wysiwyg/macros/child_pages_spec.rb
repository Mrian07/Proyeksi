#-- encoding: UTF-8



require 'spec_helper'

describe 'Wysiwyg child pages spec',
         type: :feature, js: true do
  let(:project) do
    FactoryBot.create :project,
                      enabled_module_names: %w[wiki]
  end
  let(:role) { FactoryBot.create(:role, permissions: %i[view_wiki_pages edit_wiki_pages]) }
  let(:user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end

  let(:wiki_page) do
    FactoryBot.create :wiki_page,
                      title: 'Test',
                      content: FactoryBot.build(:wiki_content, text: '# My page')
  end

  let(:parent_page) do
    FactoryBot.create :wiki_page,
                      title: 'Parent page',
                      content: FactoryBot.build(:wiki_content, text: '# parent page')
  end

  let(:child_page) do
    FactoryBot.create :wiki_page,
                      title: 'Child page',
                      content: FactoryBot.build(:wiki_content, text: '# child page')
  end

  before do
    login_as(user)

    project.wiki.pages << wiki_page
    project.wiki.pages << parent_page
    project.wiki.pages << child_page
    child_page.parent = parent_page
    child_page.save!
    project.wiki.save!
  end

  let(:editor) { ::Components::WysiwygEditor.new }

  before do
    login_as(user)
  end

  describe 'in wikis' do
    describe 'creating a wiki page' do
      before do
        visit edit_project_wiki_path(project, :test)
      end

      it 'can add and edit an child pages widget' do
        editor.in_editor do |_container, editable|
          expect(editable).to have_selector('h1', text: 'My page')

          editor.insert_macro 'Links to child pages'

          # Find widget, click to show toolbar
          placeholder = find('.op-uc-placeholder', text: 'Links to child pages')

          # Placeholder states `this page` and no `Include parent`
          expect(placeholder).to have_text('this page')
          expect(placeholder).not_to have_text('Include parent')

          # Edit widget and cancel again
          placeholder.click
          page.find('.ck-balloon-panel .ck-button', visible: :all, text: 'Edit').click
          expect(page).to have_selector('.op-modal')
          expect(page).to have_field('selected-page', with: '')
          find('.op-modal--cancel-button').click

          # Edit widget and save
          placeholder.click
          page.find('.ck-balloon-panel .ck-button', visible: :all, text: 'Edit').click
          expect(page).to have_selector('.op-modal')
          fill_in 'selected-page', with: 'parent-page'

          # Save widget
          find('.op-modal--submit-button').click

          # Placeholder states `parent-page` and no `Include parent`
          expect(placeholder).to have_text('parent-page')
          expect(placeholder).not_to have_text('Include parent')
        end

        # Save wiki page
        click_on 'Save'

        expect(page).to have_selector('.flash.notice')

        within('#content') do
          expect(page).to have_selector('.pages-hierarchy')
          expect(page).to have_selector('.pages-hierarchy', text: 'Child page')
          expect(page).not_to have_selector('.pages-hierarchy', text: 'Parent page')
          expect(page).to have_selector('h1', text: 'My page')

          SeleniumHubWaiter.wait
          find('.toolbar .icon-edit').click
        end

        editor.in_editor do |_container, _editable|
          # Find widget, click to show toolbar
          placeholder = find('.op-uc-placeholder', text: 'Links to child pages')

          # Edit widget and save
          placeholder.click
          page.find('.ck-balloon-panel .ck-button', visible: :all, text: 'Edit').click
          expect(page).to have_selector('.op-modal')
          page.check 'include-parent'

          # Save widget
          find('.op-modal--submit-button').click

          # Placeholder states `parent-page` and `Include parent`
          expect(placeholder).to have_text('parent-page')
          expect(placeholder).to have_text('Include parent')
        end

        # Save wiki page
        click_on 'Save'

        expect(page).to have_selector('.flash.notice')

        within('#content') do
          expect(page).to have_selector('.pages-hierarchy')
          expect(page).to have_selector('.pages-hierarchy', text: 'Child page')
          expect(page).to have_selector('.pages-hierarchy', text: 'Parent page')
          expect(page).to have_selector('h1', text: 'My page')

          SeleniumHubWaiter.wait
          find('.toolbar .icon-edit').click
        end
      end
    end
  end
end
