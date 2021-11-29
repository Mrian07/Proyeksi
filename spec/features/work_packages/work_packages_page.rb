

class WorkPackagesPage
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  include RSpec::Matchers

  def initialize(project = nil)
    @project = project
  end

  def visit_index(work_package = nil)
    visit index_path(work_package)

    ensure_index_page_loaded
  end

  def visit_new
    visit new_project_work_packages_path(@project)
  end

  def visit_show(id)
    visit work_package_path(id)
  end

  def visit_edit(id)
    visit edit_work_package_path(id)
  end

  def visit_calendar
    visit index_path + '/calendar'
  end

  def open_settings!
    click_on 'work-packages-settings-button'
  end

  def click_work_packages_menu_item
    find('#main-menu .work-packages').click
  end

  def click_toolbar_button(button)
    close_toasters
    find('.toolbar-container', wait: 5).click_button button
  end

  def close_toasters
    page.all(:css, '.op-toast--close').each(&:click)
  end

  def select_query(query)
    visit query_path(query)

    ensure_index_page_loaded
  end

  def find_subject_field(text = nil)
    if text
      find('#inplace-edit--write-value--subject', text: text)
    else
      find('#inplace-edit--write-value--subject')
    end
  end

  def ensure_loaded
    ensure_index_page_loaded
  end

  private

  def index_path(work_package = nil)
    path = @project ? project_work_packages_path(@project) : work_packages_path
    path += "/details/#{work_package.id}/overview" if work_package
    path
  end

  def query_path(query)
    "#{index_path}?query_id=#{query.id}"
  end

  def ensure_index_page_loaded
    if Capybara.current_driver == Capybara.javascript_driver
      expect(page).to have_selector('.work-packages--filters-optional-container.-loaded', visible: :all, wait: 20)
    end
  end
end
