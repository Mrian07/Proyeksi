#-- encoding: UTF-8

##
# Mixin to a filter or strategy
module Queries::WorkPackages::Filter::MeValueFilterMixin
  include Queries::Filters::Shared::MeValueFilter
  ##
  # Return whether the current values object has a me value
  def has_me_value?
    values.include? me_value_key
  end

  ##
  # Return the AR principal values with the me_value being replaced
  def value_objects
    principals = Principal.where(id: no_me_values).to_a

    principals.unshift(::Queries::Filters::MeValue.new) if has_me_value?

    principals
  end

  protected

  def no_me_values
    sanitized_values = values.reject { |v| v == me_value_key }
    sanitized_values = sanitized_values.reject { |v| v == User.current.id.to_s } if has_me_value?

    sanitized_values
  end
end
