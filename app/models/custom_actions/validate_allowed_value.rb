module CustomActions::ValidateAllowedValue
  private

  def validate_allowed_value(errors, attribute)
    return unless values.any?

    allowed_ids = allowed_values.map { |v| v[:value] }
    if values.to_set != (allowed_ids & values).to_set
      errors.add attribute,
                 :inclusion,
                 name: human_name
    end
  end
end
