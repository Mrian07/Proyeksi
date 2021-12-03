

require_dependency 'permitted_params'

module ProyeksiApp::Backlogs::Patches::PermittedParamsPatch
  def self.included(base)
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def update_work_package(args = {})
      permitted_params = super(args)

      backlogs_params = params.require(:work_package).permit(:story_points, :remaining_hours)
      permitted_params.merge!(backlogs_params)

      permitted_params
    end

    def my_account_settings
      backlogs_params = params.fetch(:backlogs, {}).permit(:task_color, :versions_default_fold_state)
      super.merge(backlogs: backlogs_params)
    end

    def backlogs_admin_settings
      params
        .require(:settings)
        .permit(:task_type, :points_burn_direction, :wiki_template, story_types: [])
    end
  end
end
PermittedParams.include ProyeksiApp::Backlogs::Patches::PermittedParamsPatch
