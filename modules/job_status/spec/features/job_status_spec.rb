

require 'spec_helper'

describe 'Job status', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }

  before do
    login_as admin
  end

  it 'renders a descriptive error in case of 404' do
    visit '/job_statuses/something-that-does-not-exist'

    expect(page).to have_selector('.icon-big.icon-help', wait: 10)
    expect(page).to have_content I18n.t('js.job_status.generic_messages.not_found')
  end

  describe 'with a status that has an additional errors payload' do
    let!(:status) { FactoryBot.create(:delayed_job_status, user: admin) }

    before do
      status.update! payload: { errors: ['Some error', 'Another error'] }
    end

    it 'will show a list of these errors' do
      visit "/job_statuses/#{status.job_id}"

      expect(page).to have_selector('.job-status--modal-additional-errors', text: 'Some errors have occurred', wait: 10)
      expect(page).to have_selector('ul li', text: 'Some error')
      expect(page).to have_selector('ul li', text: 'Another error')
    end
  end

  describe 'with a status with error and redirect' do
    let!(:status) { FactoryBot.create(:delayed_job_status, user: admin) }

    before do
      status.update! payload: { redirect: home_url, errors: ['Some error'] }
    end

    it 'will not automatically redirect' do
      visit "/job_statuses/#{status.job_id}"

      expect(page).to have_selector('.job-status--modal-additional-errors', text: 'Some errors have occurred', wait: 10)
      expect(page).to have_selector('ul li', text: 'Some error')
      expect(page).to have_selector("a[href='#{home_url}']", text: 'Please click here to continue')
    end
  end
end
