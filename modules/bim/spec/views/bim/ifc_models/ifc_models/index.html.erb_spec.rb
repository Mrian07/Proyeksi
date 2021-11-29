

require 'spec_helper'

describe 'bim/ifc_models/ifc_models/index', type: :view do
  let(:project) { FactoryBot.create(:project, enabled_module_names: %i[bim]) }
  let(:ifc_model) do
    FactoryBot.create(:ifc_model,
                      uploader: uploader_user,
                      title: "office.ifc",
                      project: project).tap do |model|
      model.uploader = uploader_user
    end
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[view_ifc_models manage_ifc_models])
  end
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end
  let(:uploader_user) { user }

  before do
    assign(:project, project)
    ifc_models = [ifc_model]
    allow(ifc_models).to receive(:defaults).and_return(ifc_models)
    assign(:ifc_models, ifc_models)

    controller.request.path_parameters[:project_id] = project.id

    allow(User).to receive(:current).and_return(user)
  end

  context 'with permission manage_ifc_models' do
    context 'with ifc_attachment' do
      it 'lists the IFC model with all three buttons' do
        render
        expect(rendered).to have_text('office.ifc')
        expect(rendered).to have_link('Download')
        expect(rendered).to have_link('Delete')
        expect(rendered).to have_link('Edit')
        expect(rendered).to have_text('Pending')
      end
    end

    %w[processing completed error].each do |state|
      context "with conversion_status '#{state}'" do
        before do
          ifc_model.conversion_status = ::Bim::IfcModels::IfcModel.conversion_statuses[state.to_sym]
          ifc_model.conversion_error_message = "Conversion went wrong" if state == 'error'
          render
        end

        it 'renders the conversion status to be "Processing"' do
          expect(rendered).to have_text(state.capitalize)
          expect(rendered).to have_text('Conversion went wrong') if state == 'error'
        end
      end
    end

    context 'without ifc_attachment' do
      let(:ifc_model) do
        FactoryBot.create(:ifc_model_without_ifc_attachment,
                          title: "office.ifc",
                          project: project)
      end

      it 'lists the IFC model with all but the download button' do
        render
        expect(rendered).to have_text('office.ifc')
        expect(rendered).not_to have_link('Download')
        expect(rendered).to have_link('Delete')
        expect(rendered).to have_link('Edit')
      end
    end
  end

  context 'without permission manage_ifc_models' do
    it 'only shows the download button' do
      render
      expect(rendered).to have_link('Download')
    end
  end
end
