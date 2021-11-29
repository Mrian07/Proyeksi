

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe CostTypesController, type: :controller do
  let(:admin)     { FactoryBot.create(:admin) }
  let(:cost_type) { FactoryBot.create(:cost_type) }

  describe 'DELETE destroy' do
    it 'allows an admin to delete' do
      as_logged_in_user admin do
        delete :destroy, params: { id: cost_type.id }
      end

      expect(assigns(:cost_type).deleted_at).to be_a Time
      expect(response).to redirect_to cost_types_path
      expect(flash[:notice]).to eq I18n.t(:notice_successful_lock)
    end
  end

  describe 'PATCH restore' do
    before do
      cost_type.deleted_at = DateTime.now
    end

    it 'allows an admin to restore' do
      as_logged_in_user admin do
        patch :restore, params: { id: cost_type.id }
      end

      expect(assigns(:cost_type).deleted_at).to be_nil
      expect(response).to redirect_to cost_types_path
      expect(flash[:notice]).to eq I18n.t(:notice_successful_restore)
    end
  end
end
