

require 'spec_helper'

describe 'Wysiwyg paragraphs in lists behavior (Regression #28765)',
         type: :feature, js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[wiki]) }
  let(:editor) { ::Components::WysiwygEditor.new }

  let(:wiki_page) do
    page = FactoryBot.build :wiki_page_with_content
    page.content.text = <<~MARKDOWN
      1. Step 1
         *Expected Results:* Expected 1

      2. Step 2
         *Expected Results:* Expected 2

      3. Step 3
         *Expected Results:* Expected 3
    MARKDOWN

    page
  end

  before do
    login_as(user)
    project.wiki.pages << wiki_page
    project.wiki.save!

    visit edit_project_wiki_path(project, wiki_page.slug)
  end

  it 'shows the list correctly' do
    editor.in_editor do |_container, editable|
      expect(editable).to have_selector('ol li', count: 3)
      expect(editable).to have_no_selector('ol li p')
    end
  end
end
