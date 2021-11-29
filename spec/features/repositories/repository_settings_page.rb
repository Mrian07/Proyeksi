

class RepositorySettingsPage
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  def initialize(project)
    @project = project
  end

  def visit_repository_settings
    visit project_settings_repository_path(@project.id)
  end
end
