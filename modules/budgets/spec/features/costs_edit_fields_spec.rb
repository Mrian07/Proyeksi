

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe 'Work Package budget fields', type: :feature, js: true do
  let(:type_task) { FactoryBot.create(:type_task) }
  let!(:status) { FactoryBot.create(:status, is_default: true) }
  let!(:priority) { FactoryBot.create(:priority, is_default: true) }
  let!(:project) { FactoryBot.create(:project, types: [type_task]) }
  let(:user) { FactoryBot.create :admin }
  let!(:budget) { FactoryBot.create :budget, author: user, project: project }

  let(:create_page) { ::Pages::FullWorkPackageCreate.new(project: project) }
  let(:view_page) { ::Pages::FullWorkPackage.new(project: project) }

  before do
    login_as(user)
  end

  it 'does not show read-only fields and allows setting the budget' do
    create_page.visit!

    expect(page).to have_selector('.inline-edit--container.budget')
    expect(page).to have_no_selector('.inline-edit--container.laborCosts')
    expect(page).to have_no_selector('.inline-edit--container.materialCosts')
    expect(page).to have_no_selector('.inline-edit--container.overallCosts')

    field = create_page.edit_field(:budget)
    field.set_value budget.name
    page.find('.ng-dropdown-panel .ng-option', text: budget.name).click

    field = create_page.edit_field(:subject)
    field.set_value 'Some subject'

    create_page.save!

    view_page.expect_toast(message: "Successful creation.")

    view_page.edit_field(:budget).expect_display_value budget.name
  end
end
