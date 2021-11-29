

require 'spec_helper'

describe 'Wysiwyg work package quicklink macros', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:user) { admin }
  let!(:project) { FactoryBot.create(:project, identifier: 'some-project', enabled_module_names: %w[wiki work_package_tracking]) }
  let!(:work_package) do
    FactoryBot.create(:work_package, subject: "Foo Bar", project: project, start_date: '2020-01-01', due_date: '2020-02-01')
  end
  let(:editor) { ::Components::WysiwygEditor.new }

  let(:markdown) do
    <<~MD
      # My headline

      ###{work_package.id}

      ####{work_package.id}
    MD
  end

  before do
    login_as(user)
  end

  describe 'in wikis' do
    describe 'creating a wiki page' do
      before do
        visit project_wiki_path(project, :wiki)
      end

      it 'can add and save multiple code blocks (Regression #28350)' do
        editor.in_editor do |container,|
          editor.set_markdown markdown
          expect(container).to have_selector('p', text: "###{work_package.id}")
          expect(container).to have_selector('p', text: "####{work_package.id}")
        end

        click_on 'Save'

        expect(page).to have_selector('.flash.notice')

        # Expect output widget
        within('#content') do
          expect(page).to have_selector('macro', count: 2)
          expect(page).to have_selector('span', text: 'Foo Bar', count: 2)
          expect(page).to have_selector('span', text: work_package.type.name.upcase, count: 2)
          expect(page).to have_selector('span', text: work_package.status.name, count: 1)
          # Dates are being rendered in two nested spans
          expect(page).to have_selector('span', text: '01/01/2020', count: 2)
          expect(page).to have_selector('span', text: '02/01/2020', count: 2)
          expect(page).to have_selector('.work-package--quickinfo.preview-trigger', text: "##{work_package.id}", count: 2)
        end

        # Edit page again
        click_on 'Edit'

        editor.in_editor do |container,|
          expect(container).to have_selector('p', text: "###{work_package.id}")
          expect(container).to have_selector('p', text: "####{work_package.id}")
        end
      end
    end
  end
end
