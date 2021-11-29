#-- encoding: UTF-8



class CustomValue::StringStrategy < CustomValue::FormatStrategy
  def typed_value
    value
  end

  def validate_type_of_value; end
end
