

require 'spec_helper'

require_relative '../support/pages/ifc_models/index'

describe 'model management',
         with_config: { edition: 'bim' },
         type: :feature,
         js: true do
  let(:project) { FactoryBot.create :project, enabled_module_names: %i[bim work_package_tracking] }
  let(:index_page) { Pages::IfcModels::Index.new(project) }
  let(:role) { FactoryBot.create(:role, permissions: %i[view_ifc_models manage_bcf manage_ifc_models view_work_packages]) }

  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  let!(:model) do
    FactoryBot.create(:ifc_model_minimal_converted,
                      project: project,
                      uploader: user,
                      is_default: true)
  end

  let!(:model2) do
    FactoryBot.create(:ifc_model_minimal_converted,
                      project: project,
                      uploader: user)
  end

  context 'with all permissions' do
    before do
      login_as(user)
      model
      model2
      index_page.visit!
    end

    it 'I can perform all actions on the models' do
      index_page.model_listed true, model.title
      index_page.add_model_allowed true
      index_page.edit_model_allowed model.title, true
      index_page.delete_model_allowed model.title, true

      index_page.edit_model model.title, 'My super cool new name'
      index_page.delete_model 'My super cool new name'
    end

    it 'I can see single models and the defaults' do
      index_page.model_listed true, model.title
      index_page.show_model model
      index_page.bcf_buttons true

      index_page.visit!
      index_page.model_listed true, model.title
      index_page.show_defaults([model, model2])
      index_page.bcf_buttons true
    end
  end

  context 'with only viewing permissions' do
    let(:view_role) { FactoryBot.create(:role, permissions: %i[view_ifc_models view_work_packages]) }
    let(:view_user) do
      FactoryBot.create :user,
                        member_in_project: project,
                        member_through_role: view_role
    end

    before do
      login_as(view_user)
      model
      model2
      index_page.visit!
    end

    it 'I can see, but not edit models' do
      index_page.model_listed true, model.title
      index_page.add_model_allowed false
      index_page.edit_model_allowed model.title, false
      index_page.delete_model_allowed model.title, false
    end

    it 'I can see single models and the defaults' do
      index_page.model_listed true, model.title
      index_page.show_model model

      index_page.visit!
      index_page.bcf_buttons false
      index_page.model_listed true, model.title
      index_page.show_defaults([model, model2])
    end
  end

  context 'without any permissions' do
    let(:no_permissions_role) { FactoryBot.create(:role, permissions: %i[]) }
    let(:user_without_permissions) do
      FactoryBot.create :user,
                        member_in_project: project,
                        member_through_role: no_permissions_role
    end

    before do
      login_as(user_without_permissions)
      model
      index_page.visit!
    end

    it "I can't see any models and perform no actions" do
      expected = '[Error 403] You are not authorized to access this page.'
      expect(page).to have_selector('.op-toast.-error', text: expected)

      index_page.add_model_allowed false
    end
  end
end