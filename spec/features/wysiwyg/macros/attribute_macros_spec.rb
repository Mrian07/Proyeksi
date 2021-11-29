

require 'spec_helper'

describe 'Wysiwyg attribute macros', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:user) { admin }
  let!(:project) { FactoryBot.create(:project, identifier: 'some-project', enabled_module_names: %w[wiki work_package_tracking]) }
  let!(:work_package) { FactoryBot.create(:work_package, subject: "Foo Bar", project: project) }
  let(:editor) { ::Components::WysiwygEditor.new }

  let(:markdown) do
    <<~MD
      # My headline

      <table>
        <thead>
        <tr>
          <th>Label</th>
          <th>Value</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>workPackageLabel:"Foo Bar":subject</td>
          <td>workPackageValue:"Foo Bar":subject</td>
        </tr>
        <tr>
          <td>projectLabel:identifier</td>
          <td>projectValue:identifier</td>
        </tr>
        <tr>
          <td>invalid subject workPackageValue:"Invalid":subject</td>
          <td>invalid project projectValue:"does not exist":identifier</td>
        </tr>
        </tbody>
      </table>
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
          expect(container).to have_selector('table')
        end

        click_on 'Save'

        expect(page).to have_selector('.flash.notice')

        # Expect output widget
        within('#content') do
          expect(page).to have_selector('td', text: 'Subject')
          expect(page).to have_selector('td', text: 'Foo Bar')
          expect(page).to have_selector('td', text: 'Identifier')
          expect(page).to have_selector('td', text: 'some-project')

          expect(page).to have_selector('td', text: 'invalid subject Cannot expand macro: Requested resource could not be found')
          expect(page).to have_selector('td', text: 'invalid project Cannot expand macro: Requested resource could not be found')
        end

        # Edit page again
        click_on 'Edit'

        editor.in_editor do |container,|
          expect(container).to have_selector('tbody td', count: 6)
        end
      end
    end
  end
end
