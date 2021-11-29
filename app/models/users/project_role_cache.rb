#-- encoding: UTF-8



class Users::ProjectRoleCache
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def fetch(project)
    cache[project] ||= roles(project)
  end

  private

  def roles(project)
    # No role on archived projects
    return [] unless !project || project&.active?

    # Return all roles if user is admin
    return all_givable_roles if user.admin?

    ::Authorization.roles(user, project).eager_load(:role_permissions)
  end

  def cache
    @cache ||= {}
  end

  def all_givable_roles
    @all_givable_roles ||= Role.givable.to_a
  end
end
