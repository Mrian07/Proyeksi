#-- encoding: UTF-8

class Queries::WorkPackages::Filter::RoleFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    @allowed_values ||= begin
                          roles.map { |r| [r.name, r.id.to_s] }
                        end
  end

  def available?
    roles.exists?
  end

  def type
    :list_optional
  end

  def human_name
    I18n.t('query_fields.assigned_to_role')
  end

  def self.key
    :assigned_to_role
  end

  def ar_object_filter?
    true
  end

  def value_objects
    available_roles = roles.index_by(&:id)

    values
      .map { |role_id| available_roles[role_id.to_i] }
      .compact
  end

  def where
    operator_for_filtering.sql_for_field(user_ids_for_filtering.map(&:to_s),
                                         WorkPackage.table_name,
                                         'assigned_to_id')
  end

  private

  def roles
    ::Role.givable
  end

  def operator_for_filtering
    case operator
    when '*' # Any Role
      # Override the operator since we want to find by assigned_to
      ::Queries::Operators::Equals
    when '!*' # No role
      # Override the operator since we want to find by assigned_to
      ::Queries::Operators::NotEquals
    else
      operator_strategy
    end
  end

  def user_ids_for_filtering
    scope = if ['*', '!*'].include?(operator)
              user_ids_for_filtering_scope
            elsif project
              user_ids_for_filter_project_scope
            else
              user_ids_for_filter_non_project_scope
            end

    scope.pluck(:user_id).sort.uniq
  end

  def user_ids_for_filtering_scope
    roles
      .joins(member_roles: :member)
  end

  def user_ids_for_filter_project_scope
    user_ids_for_filtering_scope
      .where(id: values)
      .where(members: { project_id: project.id })
  end

  def user_ids_for_filter_non_project_scope
    user_ids_for_filtering_scope
      .where(id: values)
  end
end
