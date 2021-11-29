#-- encoding: UTF-8



module Projects::Concerns
  module UpdateDemoData
    private

    def after_perform(call)
      project = call.result

      # e.g. when one of the demo projects gets deleted or archived
      if %w[your-scrum-project demo-project].include?(project.identifier)
        Setting.demo_projects_available = !project.destroyed? && !project.archived?
      end

      super
    end
  end
end
