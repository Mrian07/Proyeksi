

require 'spec_helper'

feature 'project settings index', type: :feature do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[manage_versions])
  end
  let(:project) { FactoryBot.create(:project) }
  let!(:version1) { FactoryBot.create(:version, name: "aaaaa 1.", project: project) }
  let!(:version2) { FactoryBot.create(:version, name: "aaaaa", project: project) }
  let!(:version3) { FactoryBot.create(:version, name: "1.10. aaa", project: project) }
  let!(:version4) { FactoryBot.create(:version, name: "1.1. zzz", project: project) }
  let!(:version5) { FactoryBot.create(:version, name: "1.2. mmm", project: project) }
  let!(:version6) { FactoryBot.create(:version, name: "1. xxxx", project: project) }

  before do
    login_as(user)
  end

  @javascript
  scenario 'see versions listed in semver order' do
    visit project_settings_versions_path(project)

    names_in_order = page.all('.version .name').map { |el| el.text.strip }

    expect(names_in_order)
      .to eql [version6.name, version4.name, version5.name, version3.name, version2.name, version1.name]
  end
end
