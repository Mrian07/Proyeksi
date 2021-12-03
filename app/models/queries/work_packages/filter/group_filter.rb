#-- encoding: UTF-8

class Queries::WorkPackages::Filter::GroupFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    all_groups.map { |g| [g.name, g.id.to_s] }
  end

  def available?
    ::Group.exists?
  end

  def type
    :list_optional
  end

  def human_name
    I18n.t('query_fields.member_of_group')
  end

  def self.key
    :member_of_group
  end

  def ar_object_filter?
    true
  end

  def value_objects
    available_groups = all_groups.index_by(&:id)

    values
      .map { |group_id| available_groups[group_id.to_i] }
      .compact
  end

  def where
    operator_for_filtering.sql_for_field(user_ids_for_filtering.map(&:to_s),
                                         WorkPackage.table_name,
                                         'assigned_to_id')
  end

  private

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
    scope = case operator
            when '*', '!*'
              all_groups
            else
              all_groups.where(id: values)
            end

    scope.joins(:users).pluck(Arel.sql('users_users.id')).uniq.sort
  end

  def all_groups
    @all_groups ||= ::Group.all
  end
end
