

require 'spec_helper'

describe 'Logout', type: :feature, js: true do
  let(:user_password) { 'b0B' * 4 }
  let(:user) do
    FactoryBot.create(:user,
                      password: user_password,
                      password_confirmation: user_password)
  end

  before do
    login_with(user.login, user_password)
  end

  it 'prevents the user from making any more changes' do
    visit my_page_path

    within '.op-app-header' do
      page.find("a[title='#{user.name}']").click

      click_link I18n.t(:label_logout)
    end

    expect(page)
      .to have_current_path home_path

    # Can not access the my page but is redirected
    # to login instead.
    visit my_page_path

    expect(page)
      .to have_field('Username')
  end
end
