

require 'spec_helper'

describe 'Refreshing query menu item', js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create :project }
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }

  let(:work_package) { FactoryBot.create :work_package, project: project }
  let(:other_work_package) { FactoryBot.create :work_package, project: project }

  before do
    login_as(user)
    work_package
    wp_table.visit!
  end

  it 'allows refreshing the current query (Bug #26921)' do
    wp_table.expect_work_package_listed work_package
    # Instantiate lazy let here
    wp_table.ensure_work_package_not_listed! other_work_package

    wp_table.save_as('Some query name')

    # Publish query
    wp_table.click_setting_item I18n.t('js.toolbar.settings.visibility_settings')
    find('#show-in-menu').set true
    find('.button', text: 'Save').click

    last_query = Query.last
    url = URI.parse(page.current_url).query
    expect(url).to include("query_id=#{last_query.id}")
    expect(url).not_to match(/query_props=.+/)

    # Locate query and refresh
    query_item = page.find(".op-sidemenu--item-action", text: last_query.name)
    query_item.click

    wp_table.expect_work_package_listed work_package, other_work_package
  end
end
