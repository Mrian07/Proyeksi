
require 'spec_helper'
require_relative '../../support/pages/ifc_models/show_default'

describe 'bcf export',
         type: :feature,
         js: true,
         with_config: { edition: 'bim' } do
  let(:status) { FactoryBot.create(:status, name: 'New', is_default: true) }
  let(:closed_status) { FactoryBot.create(:closed_status, name: 'Closed') }
  let(:project) { FactoryBot.create :project, enabled_module_names: %i[bim work_package_tracking] }

  let!(:open_work_package) { FactoryBot.create(:work_package, project: project, subject: 'Open WP', status: status) }
  let!(:closed_work_package) { FactoryBot.create(:work_package, project: project, subject: 'Closed WP', status: closed_status) }
  let!(:open_bcf_issue) { FactoryBot.create(:bcf_issue, work_package: open_work_package) }
  let!(:closed_bcf_issue) { FactoryBot.create(:bcf_issue, work_package: closed_work_package) }

  let(:permissions) do
    %i[view_ifc_models
       view_linked_issues
       manage_bcf
       add_work_packages
       edit_work_packages
       view_work_packages
       export_work_packages]
  end

  let(:current_user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_with_permissions: permissions
  end

  let!(:model) do
    FactoryBot.create(:ifc_model_minimal_converted,
                      project: project,
                      uploader: current_user)
  end

  let(:model_page) { ::Pages::IfcModels::ShowDefault.new project }
  let(:wp_cards) { ::Pages::WorkPackageCards.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }

  before do
    login_as current_user
    @download_list = DownloadList.new
  end

  after do
    DownloadList.clear
  end

  def export_into_bcf_extractor
    DownloadList.clear
    page.find('.export-bcf-button').click

    # Expect to get a response regarding queuing
    expect(page).to have_content(I18n.t('js.job_status.generic_messages.in_queue'),
                                 wait: 10)

    perform_enqueued_jobs
    expect(page).to have_text("completed successfully")

    # Close the modal
    page.find('.op-modal--close-button').click

    @download_list.refresh_from(page)

    # Check the downloaded file
    OpenProject::Bim::BcfXml::Importer.new(
      @download_list.latest_download,
      project,
      current_user: current_user
    ).extractor_list
  end

  it 'can export the open and closed BCF issues (Regression #30953)' do
    model_page.visit!
    wp_cards.expect_work_package_listed(open_work_package)
    wp_cards.expect_work_package_not_listed(closed_work_package)
    filters.expect_filter_count(1)

    # Expect only the open issue
    extractor_list = export_into_bcf_extractor
    expect(extractor_list.length).to eq(1)
    expect(extractor_list.first[:title]).to eq('Open WP')

    model_page.visit!
    # Change the query to show all statuses
    filters.open
    filters.remove_filter('status')
    filters.expect_filter_count(0)

    wp_cards.expect_work_package_listed(open_work_package, closed_work_package)

    # Download again
    extractor_list = export_into_bcf_extractor
    expect(extractor_list.length).to eq(2)

    titles = extractor_list.map { |hash| hash[:title] }
    expect(titles).to contain_exactly('Open WP', 'Closed WP')
  end
end
