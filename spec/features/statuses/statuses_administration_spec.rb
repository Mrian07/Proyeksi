

require 'spec_helper'

describe 'Statuses administration', type: :feature do
  let(:admin) { FactoryBot.create :admin }

  before do
    login_as(admin)
    visit new_status_path
  end

  describe 'with EE token', with_ee: %i[readonly_work_packages] do
    it 'allows to set readonly status' do
      expect(page).to have_field 'status[is_readonly]', disabled: false
    end
  end

  describe 'without EE token' do
    it 'does not allow to set readonly status' do
      expect(page).to have_field 'status[is_readonly]', disabled: true
    end
  end
end
