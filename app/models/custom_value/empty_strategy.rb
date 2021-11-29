#-- encoding: UTF-8



class CustomValue::EmptyStrategy < CustomValue::FormatStrategy
  def typed_value
    "#{value} #{I18n.t(:label_not_found)}"
  end

  def formatted_value
    typed_value
  end

  def validate_type_of_value; end
end
