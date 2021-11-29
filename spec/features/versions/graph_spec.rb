

require 'spec_helper'

describe 'version show graph', type: :feature, js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create(:project) }
  let(:version) { FactoryBot.create(:version, project: project) }

  let!(:wp) do
    FactoryBot.create :work_package,
                      project: project,
                      version: version
  end

  before do
    login_as(user)
    visit version_path(version)
  end

  it 'shows a status graph' do
    expect(page).to have_selector('.work-packages-embedded-view--container', wait: 20)
    expect(page).to have_selector('.chartjs-size-monitor', visible: :all, wait: 20)
  end
end
