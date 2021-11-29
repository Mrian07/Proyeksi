#-- encoding: UTF-8



require 'spec_helper'

describe EnumerationsController, type: :controller do
  shared_let(:admin) { FactoryBot.create(:admin) }

  current_user do
    admin
  end

  describe '#index' do
    before do
      get :index
    end

    it 'is successful' do
      expect(response)
        .to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response)
        .to render_template 'index'
    end
  end

  describe '#destroy' do
    let(:enum) { FactoryBot.create(:priority) }
    let(:params) { { id: enum.id } }
    let(:work_packages) { [] }

    before do
      work_packages

      delete :destroy, params: params
    end

    it 'redirects' do
      expect(response)
        .to redirect_to enumerations_path
    end

    it 'destroys the enum' do
      expect(Enumeration.where(id: enum.id))
        .not_to exist
    end

    context 'when in use' do
      let(:work_packages) { [FactoryBot.create(:work_package, priority: enum)] }

      it 'keeps the enum (as it needs to be reassigned)' do
        expect(Enumeration.where(id: enum.id))
          .to exist
      end

      it 'keeps the usage' do
        expect(work_packages.first.reload.priority)
          .to eql enum
      end

      it 'renders destroy template' do
        expect(response)
          .to render_template :destroy
      end
    end

    context 'when in use and reassigning' do
      let(:work_packages) { [FactoryBot.create(:work_package, priority: enum)] }
      let!(:other_enum) { FactoryBot.create(:priority) }
      let(:params) { { id: enum.id, reassign_to_id: other_enum.id } }

      it 'destroys the enum' do
        expect(Enumeration.where(id: enum.id))
          .not_to exist
      end

      it 'reassigns the usage' do
        expect(work_packages.first.reload.priority)
          .to eql other_enum
      end
    end
  end
end
