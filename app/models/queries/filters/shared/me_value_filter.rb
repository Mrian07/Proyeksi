#-- encoding: UTF-8

module Queries::Filters::Shared::MeValueFilter
  ##
  # Return the values object with the me value
  # mapped to the current user.
  def values_replaced
    vals = values.clone

    if vals.delete(me_value_key)
      if User.current.logged?
        vals.push(User.current.id.to_s)
      else
        vals.push('0')
      end
    end

    vals
  end

  protected

  ##
  # Returns the me value if the user is logged
  def me_allowed_value
    values = []
    if User.current.logged?
      values << [me_label, me_value_key]
    end
    values
  end

  def me_label
    I18n.t(:label_me)
  end

  def me_value_key
    ::Queries::Filters::MeValue::KEY
  end
end
