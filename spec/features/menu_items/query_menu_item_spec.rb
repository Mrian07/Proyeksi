

require 'spec_helper'
require 'features/page_objects/notification'
require 'features/work_packages/shared_contexts'
require 'features/work_packages/work_packages_page'

RSpec.feature 'Query menu items', js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create :project }
  let(:work_packages_page) { WorkPackagesPage.new(project) }
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:notification) { PageObjects::Notifications.new(page) }
  let(:query_title) { ::Components::WorkPackages::QueryTitle.new }
  let(:status) { FactoryBot.create :status }

  def visit_index_page(query)
    work_packages_page.select_query(query)
  end

  before do
    status

    allow(User).to receive(:current).and_return user
  end

  context 'with identical names' do
    let(:query_a) { FactoryBot.create :public_query, name: 'some query.', project: project }
    let(:query_b) { FactoryBot.create :public_query, name: query_a.name, project: project }

    let!(:menu_item_a) { FactoryBot.create :query_menu_item, query: query_a }
    let!(:menu_item_b) { FactoryBot.create :query_menu_item, query: query_b }

    it 'can be shown' do
      visit_index_page(query_a)

      wp_table.visit_query query_a
      wp_table.expect_title query_a.name
    end
  end

  context 'with dots in their name' do
    let(:query) { FactoryBot.create :public_query, name: 'OP 3.0', project: project }

    it 'can be added', js: true, selenium: true do
      visit_index_page(query)

      click_on 'Settings'
      click_on I18n.t('js.toolbar.settings.visibility_settings')
      check 'Favored'
      click_on 'Save'

      notification.expect_success('Successful update')
      expect(page).to have_selector('.op-sidemenu--item', text: query.name)
    end

    after do
      work_packages_page.ensure_loaded
    end
  end

  describe 'renaming a menu item' do
    let(:query_a) { FactoryBot.create :query, name: 'bbbb', project: project, user: user }
    let(:query_b) { FactoryBot.create :query, name: 'zzzz', project: project, user: user }

    let!(:menu_item_a) { FactoryBot.create :query_menu_item, query: query_a }
    let!(:menu_item_b) { FactoryBot.create :query_menu_item, query: query_b }
    let(:new_name) { 'aaaaa' }

    before do
      visit_index_page(query_b)

      query_title.expect_title 'zzzz'
      input = query_title.input_field
      input.set new_name
      input.send_keys :return
    end

    after do
      work_packages_page.ensure_loaded
    end

    it 'displaying a success message' do
      notification.expect_success('Successful update')
    end

    it 'is renaming and reordering the list' do
      # Renaming the query should also reorder the queries.  As it is renamed
      # from zzzz to aaaa, it should now be the first query menu item.
      expect(page).to have_selector('li:nth-child(3) a', text: new_name)
    end
  end
end
