

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require_relative 'support/pages/cost_report_page'

describe "updating a cost report's cost type", type: :feature, js: true do
  let(:project) { FactoryBot.create :project_with_types, members: { user => FactoryBot.create(:role) } }
  let(:user) do
    FactoryBot.create(:admin)
  end

  let(:cost_type) do
    FactoryBot.create :cost_type, name: 'Post-war', unit: 'cap', unit_plural: 'caps'
  end

  let!(:cost_entry) do
    FactoryBot.create :cost_entry, user: user, project: project, cost_type: cost_type
  end

  let(:report_page) { ::Pages::CostReportPage.new project }

  before do
    login_as(user)
  end

  it 'works' do
    report_page.visit!
    report_page.save(as: 'My Query', public: true)
    SeleniumHubWaiter.wait
    report_page.switch_to_type cost_type.name
    click_on "Save"

    click_on "My Query"
    expect(page).to have_field(cost_type.name, checked: true)
  end
end
