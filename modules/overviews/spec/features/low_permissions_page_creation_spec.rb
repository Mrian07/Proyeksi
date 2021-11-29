

require 'spec_helper'

require_relative '../support/pages/overview'

describe 'Overview page on the fly creation if user lacks :mange_overview permission',
         type: :feature, js: true, with_mail: false do
  let!(:type) { FactoryBot.create :type }
  let!(:project) { FactoryBot.create :project, types: [type] }
  let!(:open_status) { FactoryBot.create :default_status }

  let(:permissions) do
    %i[view_work_packages]
  end

  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end
  let(:overview_page) do
    Pages::Overview.new(project)
  end

  before do
    login_as user

    overview_page.visit!
  end

  it 'renders the default view, allows altering and saving' do
    description_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')
    details_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(2)')
    overview_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(3)')

    description_area.expect_to_exist
    details_area.expect_to_exist
    overview_area.expect_to_exist
  end
end
