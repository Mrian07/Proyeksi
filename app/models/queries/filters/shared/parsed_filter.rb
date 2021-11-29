

module Queries::Filters::Shared::ParsedFilter
  def type
    :string
  end

  def where
    case operator
    when '='
      value_conditions.join(' OR ')
    when '!'
      "NOT #{value_conditions.join(' AND NOT ')}"
    end
  end

  def available_operators
    [Queries::Operators::Equals,
     Queries::Operators::NotEquals]
  end

  private

  def split_values
    raise NotImplementedError
  end

  def value_conditions
    raise NotImplementedError
  end

  def validate_values
    super

    errors.add(:values, "malformed value") if split_values.any?(&:nil?)
  end
end
