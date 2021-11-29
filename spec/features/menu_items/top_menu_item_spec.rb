

require 'spec_helper'

feature 'Top menu items', js: true, selenium: true do
  let(:user) { FactoryBot.create :user }
  let(:open_menu) { true }

  def has_menu_items?(*labels)
    within '.op-app-header' do
      labels.each do |l|
        expect(page).to have_link(l)
      end
      (all_items - labels).each do |l|
        expect(page).not_to have_link(l)
      end
    end
  end

  def click_link_in_open_menu(title)
    # if the menu is not completely expanded (e.g. if the frontend thread is too fast),
    # the click might be ignored

    within '.op-app-menu--dropdown[aria-expanded=true]' do
      expect(page).not_to have_selector('[style~=overflow]')

      page.find_link(title).find('span').click
    end
  end

  before do |ex|
    allow(User).to receive(:current).and_return user
    FactoryBot.create(:anonymous_role)
    FactoryBot.create(:non_member)

    if ex.metadata.key?(:allowed_to)
      allow(user).to receive(:allowed_to?).and_return(ex.metadata[:allowed_to])
    end

    visit root_path
    top_menu.click if open_menu
  end

  describe 'Modules' do
    !let(:top_menu) { find(:css, "[title=#{I18n.t('label_modules')}]") }

    let(:news_item) { I18n.t('label_news_plural') }
    let(:project_item) { I18n.t('label_projects_menu') }
    let(:reporting_item) { I18n.t('cost_reports_title') }

    let(:all_items) { [news_item, project_item, reporting_item] }

    context 'as an admin' do
      let(:user) { FactoryBot.create :admin }
      it 'displays all items' do
        has_menu_items?(reporting_item, news_item, project_item)
      end

      it 'visits the news page' do
        click_link_in_open_menu(news_item)
        expect(page).to have_current_path(news_index_path)
      end
    end

    context 'as a regular user' do
      it 'displays news and projects only' do
        has_menu_items? news_item, project_item
      end
    end

    context 'as a user with permissions', allowed_to: true do
      it 'displays all options' do
        has_menu_items?(reporting_item, news_item, project_item)
      end
    end

    context 'as an anonymous user' do
      let(:user) { FactoryBot.create :anonymous }
      it 'displays only news and projects' do
        has_menu_items? news_item, project_item
      end
    end
  end

  describe 'Projects' do
    let(:top_menu) { find(:css, '#projects-menu') }

    let(:all_projects) { I18n.t(:label_project_view_all) }
    let(:all_items) { [all_projects] }

    context 'as an admin' do
      let(:user) { FactoryBot.create :admin }
      it 'displays all items' do
        has_menu_items?(all_projects)
      end

      it 'visits the projects page' do
        click_link_in_open_menu(all_projects)

        expect(page).to have_current_path(projects_path)
      end
    end

    context 'as a user without project permission' do
      before do
        Role.non_member.update_attribute :permissions, [:view_project]
      end
      it 'does not display new_project' do
        has_menu_items? all_projects
      end
    end

    context 'as an anonymous user' do
      let(:user) { FactoryBot.create :anonymous }
      let(:open_menu) { false }

      it 'does not show the menu' do
        expect(page).to have_no_selector('#projects-menu')
      end
    end
  end
end
