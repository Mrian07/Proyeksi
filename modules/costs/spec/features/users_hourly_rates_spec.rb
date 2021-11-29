

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe 'hourly rates on user edit', type: :feature, js: true do
  let(:user) { FactoryBot.create :admin }

  def view_rates
    visit edit_user_path(user, tab: 'rates')
  end

  before do
    allow(User).to receive(:current).and_return user
  end

  context 'with no rates' do
    before do
      view_rates
    end

    it 'shows no data message' do
      expect(page).to have_text I18n.t('no_results_title_text')
    end
  end

  context 'with rates' do
    let!(:rate) { FactoryBot.create(:default_hourly_rate, user: user) }

    before do
      view_rates
    end

    it 'shows the rates' do
      expect(page).to have_text 'Current rate'.upcase
    end

    describe 'deleting all rates' do
      before do
        click_link 'Update'         # go to update view for rates
        SeleniumHubWaiter.wait
        find('.icon-delete').click  # delete last existing rate
        click_on 'Save'             # save change
      end

      # regression test: clicking save used to result in a error
      it 'leads back to the now empty rate overview' do
        expect(page).to have_text /rate history/i
        expect(page).to have_text I18n.t('no_results_title_text')

        expect(page).to have_no_text 'Current rate'
      end
    end
  end
end
