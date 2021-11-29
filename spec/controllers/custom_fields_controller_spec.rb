

require 'spec_helper'

describe CustomFieldsController, type: :controller do
  shared_let(:admin) { FactoryBot.create :admin }

  let(:custom_field) { FactoryBot.build_stubbed(:custom_field) }

  before do
    login_as admin
  end

  describe 'POST edit' do
    before do
      allow(CustomField).to receive(:find).and_return(custom_field)
      allow(custom_field).to receive(:save).and_return(true)
    end

    describe 'WITH all ok params' do
      let(:params) do
        {
          'custom_field' => { 'name' => 'Issue Field' }
        }
      end

      before do
        put :update, params: params.merge(id: custom_field.id)
      end

      it 'works' do
        expect(response).to be_redirect
        expect(custom_field.name).to eq('Issue Field')
      end
    end
  end

  describe 'POST new' do
    describe 'WITH empty name param' do
      let(:params) do
        {
          'type' => 'WorkPackageCustomField',
          'custom_field' => {
            'name' => '',
            'field_format' => 'string'
          }
        }
      end

      before do
        post :create, params: params
      end

      it 'responds with error' do
        expect(response).to render_template 'new'
        expect(assigns(:custom_field).errors.messages[:name].first).to eq("can't be blank.")
      end
    end

    describe 'WITH all ok params' do
      let(:params) do
        {
          'type' => 'WorkPackageCustomField',
          'custom_field' => {
            'name' => 'field',
            'field_format' => 'string'
          }
        }
      end

      before do
        post :create, params: params
      end

      it 'responds ok' do
        expect(response).to be_redirect
        expect(CustomField.last.name).to eq 'field'
      end
    end
  end
end
