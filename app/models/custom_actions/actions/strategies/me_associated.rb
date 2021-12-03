#-- encoding: UTF-8

module CustomActions::Actions::Strategies::MeAssociated
  include ::CustomActions::Actions::Strategies::Associated

  def associated
    me_value = [current_user_value_key, I18n.t('custom_actions.actions.assigned_to.executing_user_value')]

    [me_value] + available_principles
  end

  def values=(values)
    values = Array(values).map do |v|
      if v == current_user_value_key
        v
      else
        to_integer_or_nil(v)
      end
    end

    @values = values.uniq
  end

  ##
  # Returns the me value if the user is logged
  def transformed_value(val)
    return val unless has_me_value?

    if User.current.logged?
      User.current.id
    end
  end

  def current_user_value_key
    'current_user'.freeze
  end

  def has_me_value?
    values.first == current_user_value_key
  end

  def validate(errors)
    super
    validate_me_value(errors)
  end

  private

  def validate_me_value(errors)
    if has_me_value? && !User.current.logged?
      errors.add :actions,
                 :not_logged_in,
                 name: human_name
    end
  end
end
