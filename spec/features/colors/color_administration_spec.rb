

require 'spec_helper'

feature 'color administration', type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }

  before do
    login_as(admin)
  end

  scenario 'CRUD' do
    # Only a stub for now

    visit colors_path

    expect(page)
      .to have_content(I18n.t(:'colors.index.no_results_title_text'))

    click_link I18n.t(:'colors.index.no_results_content_text')
  end
end
