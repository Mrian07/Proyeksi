

require 'spec_helper'

describe 'Editing a new wiki page', type: :feature, js: true do
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[wiki]) }
  let(:user) { FactoryBot.create :admin }

  before do
    login_as(user)
  end

  it 'allows creating a wiki page from link' do
    visit project_wiki_path(project, id: :foobar)
    expect(page).to have_field 'content_page_title', with: 'Foobar'
    click_on 'Save'

    expect(page).to have_selector('.flash.notice', text: 'Successful creation.', wait: 10)
  end
end
