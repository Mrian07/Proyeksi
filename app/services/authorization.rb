#-- encoding: UTF-8

class Authorization
  # Returns all users having a certain permission within a project
  def self.users(action, project)
    Authorization::UserAllowedQuery.query(action, project)
  end

  # Returns all projects a user has a certain permission in
  def self.projects(action, user)
    Authorization::ProjectQuery.query(user, action)
  end

  # Returns all roles a user has in a certain project or globally
  def self.roles(user, project = nil)
    if project
      Authorization::UserProjectRolesQuery.query(user, project)
    else
      Authorization::UserGlobalRolesQuery.query(user)
    end
  end
end
