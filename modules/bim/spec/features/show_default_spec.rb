

require_relative '../spec_helper'

describe 'show default model',
         with_config: { edition: 'bim' },
         type: :feature,
         js: true do
  let(:project) { FactoryBot.create :project, enabled_module_names: %i[bim work_package_tracking] }
  let(:index_page) { Pages::IfcModels::Index.new(project) }
  let(:show_default_page) { Pages::IfcModels::ShowDefault.new(project) }
  let(:role) { FactoryBot.create(:role, permissions: %i[view_ifc_models view_work_packages manage_ifc_models]) }

  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  let(:model) do
    FactoryBot.create(:ifc_model_minimal_converted,
                      is_default: model_is_default,
                      project: project,
                      uploader: user)
  end
  let(:model_is_default) { true }
  let(:model_tree) { ::Components::XeokitModelTree.new }

  before do
    login_as(user)
    model
  end

  context 'when the work package module not loaded' do
    let(:project) { FactoryBot.create :project, enabled_module_names: [:bim] }

    it 'shows an error loading the page' do
      show_default_page.visit!
      show_default_page.expect_toast(type: :error, message: 'Your view is erroneous and could not be processed')
    end
  end

  context 'with everything ready' do
    let(:old_work_package) { FactoryBot.create(:work_package, project: project) }
    let(:new_work_package) { FactoryBot.create(:work_package, project: project) }

    before do
      old_work_package
      new_work_package

      show_default_page.visit!
      show_default_page.finished_loading
    end

    it 'loads and shows the viewer and WPs correctly' do
      show_default_page.model_viewer_visible true
      show_default_page.model_viewer_shows_a_toolbar true
      show_default_page.page_shows_a_toolbar true
      model_tree.sidebar_shows_viewer_menu true

      # Check the order of work packages: Latest first
      expect(show_default_page.find_all('.op-wp-single-card--content-id').map(&:text)).to(
        eql(["##{new_work_package.id}", "##{old_work_package.id}"])
      )
    end
  end

  context 'with the default model not being processed' do
    before do
      model.xkt_attachment.destroy

      show_default_page.visit!
    end

    it 'renders a notification' do
      show_default_page
        .expect_toast(type: :info,
                             message: I18n.t(:'ifc_models.processing_notice.processing_default'))
    end
  end
end
