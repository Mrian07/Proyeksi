module CustomActions::Actions::Strategies::ValidateInRange
  def minimum
    nil
  end

  def maximum
    nil
  end

  def validate(errors)
    super
    validate_in_interval(errors)
  end

  private

  def validate_in_interval(errors)
    return unless values.compact.length == 1

    validate_greater_than_minimum(errors)
    validate_smaller_than_maximum(errors)
  end

  def validate_smaller_than_maximum(errors)
    if maximum && values[0] > maximum
      errors.add :actions,
                 :smaller_than_or_equal_to,
                 name: human_name,
                 count: maximum
    end
  end

  def validate_greater_than_minimum(errors)
    if minimum && values[0] < minimum
      errors.add :actions,
                 :greater_than_or_equal_to,
                 name: human_name,
                 count: minimum
    end
  end
end
