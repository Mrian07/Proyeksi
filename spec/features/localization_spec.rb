#-- encoding: UTF-8



require 'spec_helper'

describe 'Localization', type: :feature, with_settings: { login_required?: false,
                                                          available_languages: %i[de en],
                                                          default_language: 'en' } do
  it 'set localization' do
    Capybara.current_session.driver.header('Accept-Language', 'de,de-de;q=0.8,en-us;q=0.5,en;q=0.3')

    # a french user
    visit projects_path

    expect(page)
      .to have_content('Projekte')

    # not a supported language: default language should be used
    Capybara.current_session.driver.header('Accept-Language', 'zz')
    visit projects_path

    expect(page)
      .to have_content('Projects')
  end
end
