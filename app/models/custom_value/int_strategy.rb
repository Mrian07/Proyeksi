#-- encoding: UTF-8

class CustomValue::IntStrategy < CustomValue::FormatStrategy
  def typed_value
    unless value.blank?
      value.to_i
    end
  end

  def validate_type_of_value
    return :not_an_integer if value.is_a? Float

    begin
      Kernel.Integer(value)
      nil
    rescue StandardError
      :not_an_integer
    end
  end
end
