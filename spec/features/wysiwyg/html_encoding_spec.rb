

require 'spec_helper'

describe 'Wysiwyg escaping HTML entities (Regression #28906)',
         type: :feature, js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[wiki]) }
  let(:editor) { ::Components::WysiwygEditor.new }

  before do
    login_as(user)
    visit project_wiki_path(project, :wiki)
  end

  it 'shows the list correctly' do
    editor.in_editor do |_, editable|
      editor.click_and_type_slowly '<node foo="bar" />',
                                   :enter,
                                   '\<u>foo\</u>'

      expect(editable).to have_no_selector('node')
      expect(editable).to have_no_selector('u')
    end

    # Save wiki page
    click_on 'Save'

    expect(page).to have_selector('.flash.notice')

    within('#content') do
      expect(page).to have_selector('p', text: '<node foo="bar" />')
      expect(page).to have_no_selector('u')
      expect(page).to have_no_selector('node')
    end

    text = ::WikiContent.last.text
    expect(text).to include "&lt;node foo=&quot;bar&quot; /&gt;"
    expect(text).to include "\\\\&lt;u&gt;foo\\\\&lt;/u&gt;"
    expect(text).not_to include '<node>'
    expect(text).not_to include '<u>'
  end
end
