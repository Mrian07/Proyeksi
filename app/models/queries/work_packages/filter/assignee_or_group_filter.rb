#-- encoding: UTF-8



class Queries::WorkPackages::Filter::AssigneeOrGroupFilter <
  Queries::WorkPackages::Filter::PrincipalBaseFilter
  def allowed_values
    @allowed_values ||= begin
      values = principal_loader.user_values + principal_loader.group_values
      me_allowed_value + values.sort
    end
  end

  def type
    :list_optional
  end

  def human_name
    I18n.t('query_fields.assignee_or_group')
  end

  def self.key
    :assignee_or_group
  end

  def where
    operator_strategy.sql_for_field(
      values_replaced,
      self.class.model.table_name,
      'assigned_to_id'
    )
  end

  private

  def values_replaced
    vals = super
    vals += group_members_added(vals)
    vals + user_groups_added(vals)
  end

  def group_members_added(vals)
    User
      .joins(:groups)
      .where(groups_users: { id: vals })
      .pluck(:id)
      .map(&:to_s)
  end

  def user_groups_added(vals)
    Group
      .joins(:users)
      .where(users_users: { id: vals })
      .pluck(:id)
      .map(&:to_s)
  end
end
