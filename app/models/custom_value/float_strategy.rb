#-- encoding: UTF-8

class CustomValue::FloatStrategy < CustomValue::FormatStrategy
  include ActionView::Helpers::NumberHelper

  def typed_value
    unless value.blank?
      value.to_f
    end
  end

  def formatted_value
    number_with_delimiter(value.to_s)
  end

  def validate_type_of_value
    Kernel.Float(value)
    nil
  rescue StandardError
    :not_a_number
  end
end
