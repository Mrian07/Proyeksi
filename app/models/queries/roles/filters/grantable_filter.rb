#-- encoding: UTF-8

# This does filter for whether a role can be assigned to a member.
class Queries::Roles::Filters::GrantableFilter < Queries::Roles::Filters::RoleFilter
  def type
    :list
  end

  def where
    db_values = if values.first == ProyeksiApp::Database::DB_VALUE_TRUE
                  [Role::NON_BUILTIN]
                else
                  [Role::BUILTIN_ANONYMOUS, Role::BUILTIN_NON_MEMBER]
                end

    if operator == '='
      ["roles.builtin IN (?)", db_values]
    else
      ["roles.builtin NOT IN (?)", db_values]
    end
  end

  def allowed_values
    [[I18n.t(:general_text_yes), ProyeksiApp::Database::DB_VALUE_TRUE],
     [I18n.t(:general_text_no), ProyeksiApp::Database::DB_VALUE_FALSE]]
  end
end
