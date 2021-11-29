

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe HourlyRatesController do
  shared_let(:admin) { FactoryBot.create :admin }

  let(:user) { FactoryBot.create(:user) }
  let(:default_rate) { FactoryBot.create(:default_hourly_rate, user: user) }

  describe 'PUT update' do
    describe 'WHEN trying to update with an invalid rate value' do
      let(:params) do
        {
          id: user.id,
          user: { 'existing_rate_attributes' => { default_rate.id.to_s => { 'valid_from' => default_rate.valid_from.to_s,
                                                                            'rate' => '2d5' } } }
        }
      end
      before do
        as_logged_in_user admin do
          post :update, params: params
        end
      end

      it 'should render the edit template' do
        expect(response).to render_template('edit')
      end

      it 'should display an error message' do
        actual_message = assigns(:user).default_rates.first.errors.messages[:rate].first
        expect(actual_message).to eq(I18n.t('activerecord.errors.messages.not_a_number'))
      end
    end
  end
end
