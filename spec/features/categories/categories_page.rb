

class CategoriesPage
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  def initialize(project = nil)
    @project = project
  end

  def visit_settings
    visit(project_settings_categories_path(@project))
  end
end
