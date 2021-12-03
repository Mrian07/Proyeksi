#-- encoding: UTF-8



class
  CustomValue::FormattableStrategy < CustomValue::FormatStrategy
  def formatted_value
    ProyeksiApp::TextFormatting::Renderer.format_text value
  end

  def typed_value
    value.to_s
  end

  def validate_type_of_value; end
end
