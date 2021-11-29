#-- encoding: UTF-8



require 'spec_helper'

describe WorkflowsController, type: :controller do
  let(:current_user) { FactoryBot.build_stubbed(:admin) }
  let!(:role) do
    FactoryBot.build_stubbed(:role).tap do |r|
      allow(Role)
        .to receive(:find)
        .with(r.id.to_s)
        .and_return(r)
    end
  end
  let!(:type) do
    FactoryBot.build_stubbed(:type) do |t|
      allow(Type)
        .to receive(:find)
        .with(t.id.to_s)
        .and_return(t)
    end
  end

  before do
    login_as(current_user)
  end

  describe '#index' do
    let(:counts) { double('wf counts') }

    before do
      allow(Workflow)
        .to receive(:count_by_type_and_role)
        .and_return(counts)

      get :show
    end

    it 'is successful' do
      expect(response)
        .to be_successful
    end

    it 'assigns the workflows by type and role' do
      expect(assigns[:workflow_counts])
        .to eql counts
    end
  end

  describe '#update' do
    let(:status_params) { { "1" => "2" } }
    let(:service) do
      service = double('service')

      allow(Workflows::BulkUpdateService)
        .to receive(:new)
        .with(role: role, type: type)
        .and_return(service)

      service
    end
    let!(:call) do
      expect(service)
        .to receive(:call)
        .with(status_params)
        .and_return(call_result)
    end
    let(:call_result) { ServiceResult.new success: true }
    let(:params) do
      {
        role_id: role.id,
        type_id: type.id,
        status: status_params
      }
    end

    before do
      post :update, params: params
    end

    it 'redirects to edit' do
      expect(response)
        .to redirect_to edit_workflows_path(role_id: role.id, type_id: type.id)
    end
  end
end
