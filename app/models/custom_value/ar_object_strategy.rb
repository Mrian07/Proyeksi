#-- encoding: UTF-8



class CustomValue::ARObjectStrategy < CustomValue::FormatStrategy
  def typed_value
    return memoized_typed_value if memoized_typed_value

    unless value.blank?
      RequestStore.fetch(:"#{ar_class.name.underscore}_custom_value_#{value}") do
        self.memoized_typed_value = ar_object(value)
      end
    end
  end

  def formatted_value
    typed_value.to_s
  end

  def parse_value(val)
    if val.is_a?(ar_class)
      self.memoized_typed_value = val

      val.id.to_s
    elsif val.blank?
      super(nil)
    else
      super
    end
  end

  def validate_type_of_value
    unless custom_field.possible_values(custom_value.customized).include?(value)
      :inclusion
    end
  end

  private

  def ar_class
    raise NotImplementedError
  end

  def ar_object(_value)
    raise NotImplementedError
  end
end
