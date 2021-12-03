#-- encoding: UTF-8

# This filters for the type of role (project or global)
class Queries::Roles::Filters::UnitFilter < Queries::Roles::Filters::RoleFilter
  def type
    :list
  end

  def where
    if operator == '!'
      ["roles.type != ?", db_values]
    elsif values.first == 'project'
      ["roles.type = ? AND roles.builtin = ?", db_values, Role::NON_BUILTIN]
    else
      ["roles.type = ?", db_values]
    end
  end

  def allowed_values
    [%w(system system),
     %w(project project)]
  end

  private

  def db_values
    if values.first == 'system'
      [GlobalRole.name.to_s]
    else
      [Role.name.to_s]
    end
  end
end
