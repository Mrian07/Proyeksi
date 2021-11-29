

class CostQuery::Filter::UserId < Report::Filter::Base
  def self.label
    WorkPackage.human_attribute_name(:user)
  end

  def self.me_value
    'me'.freeze
  end

  def transformed_values
    # Map the special 'me' value
    super
        .map { |val| replace_me_value(val) }
        .compact
  end

  def replace_me_value(value)
    return value unless value == CostQuery::Filter::UserId.me_value

    if User.current.logged?
      User.current.id
    end
  end

  def self.available_values(*)
    # All users which are members in projects the user can see.
    # Excludes the anonymous user
    users = User.joins(members: :project)
                .merge(Project.visible)
                .human
                .select(User::USER_FORMATS_STRUCTURE[Setting.user_format].map(&:to_s) << :id)
                .distinct

    values = users.map { |u| [u.name, u.id] }
    values.unshift [::I18n.t(:label_me), me_value] if User.current.logged?
    values
  end
end
