#-- encoding: UTF-8



class Users::ProjectAuthorizationCache
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def cache(actions)
    cached_actions = if actions.is_a?(Array)
                       actions
                     else
                       [actions]
                     end

    cached_actions.each do |action|
      allowed_project_ids = Project.allowed_to(user, action).pluck(:id)

      projects_by_actions[normalized_permission_name(action)] = allowed_project_ids
    end
  end

  def cached?(action)
    projects_by_actions[normalized_permission_name(action)]
  end

  def allowed?(action, project)
    projects_by_actions[normalized_permission_name(action)].include? project.id
  end

  private

  def normalized_permission_name(action)
    ProyeksiApp::AccessControl.permission(action)
  end

  def projects_by_actions
    @projects_by_actions ||= {}
  end
end
