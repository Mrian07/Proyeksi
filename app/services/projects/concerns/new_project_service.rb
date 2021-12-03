#-- encoding: UTF-8



module Projects::Concerns
  module NewProjectService
    private

    def after_perform(attributes_call)
      new_project = attributes_call.result

      set_default_role(new_project) unless user.admin?
      notify_project_created(new_project)

      super
    end

    # Add default role to the newly created project
    # based on the setting ('new_project_user_role_id')
    # defined in the administration. Will either create a new membership
    # or add a role to an already existing one.
    def set_default_role(new_project)
      role = Role.in_new_project

      return unless role && new_project.persisted?

      # Assuming the members are loaded anyway
      user_member = new_project.members.detect { |m| m.principal == user }

      if user_member
        Members::UpdateService
          .new(user: user, model: user_member, contract_class: EmptyContract)
          .call(roles: user_member.roles + [role])
      else
        Members::CreateService
          .new(user: user, contract_class: EmptyContract)
          .call(roles: [role], project: new_project, principal: user)
      end
    end

    def notify_project_created(new_project)
      ProyeksiApp::Notifications.send(
        ProyeksiApp::Events::PROJECT_CREATED,
        project: new_project
      )
    end
  end
end
