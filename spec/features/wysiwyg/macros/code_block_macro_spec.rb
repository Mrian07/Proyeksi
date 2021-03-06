

require 'spec_helper'

describe 'Wysiwyg code block macro',
         type: :feature,
         js: true do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:user) { admin }
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[wiki]) }
  let(:editor) { ::Components::WysiwygEditor.new }

  let(:snippet) do
    <<~RUBY
      def foobar
        'some ruby code'
      end
    RUBY
  end

  let(:expected) do
    <<~EXPECTED
      ```ruby
      #{snippet.strip}
      ```
    EXPECTED
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
          editor.set_markdown expected

          # Expect first macro saved to editor
          expect(container).to have_selector('.op-uc-code-block', text: snippet)
          expect(container).to have_selector('.op-uc-code-block--language', text: 'ruby')

          editor.set_markdown "#{expected}\n#{expected}"
          expect(container).to have_selector('.op-uc-code-block', text: snippet, count: 2)
          expect(container).to have_selector('.op-uc-code-block--language', text: 'ruby', count: 2)
        end

        click_on 'Save'
        expect(page).to have_selector('.flash.notice')

        # Expect output widget
        within('#content') do
          expect(page).to have_selector('pre.highlight-ruby', count: 2)
        end

        SeleniumHubWaiter.wait
        # Edit page again, expect widget
        click_on 'Edit'
        # SeleniumHubWaiter.wait

        editor.in_editor do |container,|
          expect(container).to have_selector('.op-uc-code-block', text: snippet, count: 2)
          expect(container).to have_selector('.op-uc-code-block--language', text: 'ruby', count: 2)
        end
      end

      it 'respects the inserted whitespace' do
        editor.in_editor do |container,|
          editor.click_toolbar_button 'Insert code snippet'

          expect(page).to have_selector('.op-modal')

          # CM wraps an accessor to the editor instance on the outer container
          cm = page.find('.CodeMirror')
          page.execute_script('arguments[0].CodeMirror.setValue(arguments[1]);', cm.native, 'asdf')
          find('.op-modal--submit-button').click

          expect(container).to have_selector('.op-uc-code-block', text: 'asdf')

          click_on 'Save'
          expect(page).to have_selector('.flash.notice')

          wp = WikiPage.last
          expect(wp.content.text.gsub("\r\n", "\n")).to eq("```text\nasdf\n```")

          SeleniumHubWaiter.wait
          click_on 'Edit'

          editor.in_editor do |container,|
            expect(container).to have_selector('.op-uc-code-block', text: 'asdf')
          end

          click_on 'Save'
          expect(page).to have_selector('.flash.notice')

          wp.reload
          # Regression added two newlines before fence here
          expect(wp.content.text.gsub("\r\n", "\n")).to eq("```text\nasdf\n```")
        end
      end

      it 'can add and edit a code block widget' do
        editor.in_editor do |container,|
          editor.click_toolbar_button 'Insert code snippet'

          expect(page).to have_selector('.op-modal')

          # CM wraps an accessor to the editor instance on the outer container
          cm = page.find('.CodeMirror')
          page.execute_script('arguments[0].CodeMirror.setValue(arguments[1]);', cm.native, snippet)

          fill_in 'selected-language', with: 'ruby'

          # Expect some highlighting classes
          expect(page).to have_selector('.cm-keyword', text: 'def')
          expect(page).to have_selector('.cm-def', text: 'foobar')

          find('.op-modal--submit-button').click

          # Expect macro saved to editor
          expect(container).to have_selector('.op-uc-code-block', text: snippet)
          expect(container).to have_selector('.op-uc-code-block--language', text: 'ruby')
        end

        # Save wiki page
        click_on 'Save'

        expect(page).to have_selector('.flash.notice')

        wiki_page = project.wiki.find_page('wiki')
        text = wiki_page.content.text.gsub(/\r\n?/, "\n")
        expect(text.strip).to eq(expected.strip)

        # Expect output widget
        within('#content') do
          expect(page).to have_selector('pre.highlight-ruby')
        end

        # Edit page again, expect widget
        SeleniumHubWaiter.wait
        click_on 'Edit'

        editor.in_editor do |container,|
          expect(container).to have_selector('.op-uc-code-block', text: snippet)
          expect(container).to have_selector('.op-uc-code-block--language', text: 'ruby')

          widget = container.find('.op-uc-code-block')
          page.driver.browser.action.double_click(widget.native).perform
          expect(page).to have_selector('.op-modal')

          expect(page).to have_selector('.op-uc-code-block--language', text: 'ruby')
          expect(page).to have_selector('.cm-keyword', text: 'def')
          expect(page).to have_selector('.cm-def', text: 'foobar')
        end
      end
    end
  end
end
