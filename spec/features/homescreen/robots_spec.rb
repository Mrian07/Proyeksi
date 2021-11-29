

require 'spec_helper'

describe 'robots.txt', type: :feature do
  let!(:project) { FactoryBot.create(:public_project) }

  before do
    visit '/robots.txt'
  end

  it 'disallows global paths and paths from public project' do
    expect(page).to have_content('Disallow: /work_packages/calendar')
    expect(page).to have_content('Disallow: /activity')

    expect(page).to have_content("Disallow: /projects/#{project.identifier}/repository")
    expect(page).to have_content("Disallow: /projects/#{project.identifier}/work_packages")
    expect(page).to have_content("Disallow: /projects/#{project.identifier}/activity")
  end
end
