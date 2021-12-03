

module CustomActions::Actions::Strategies::Boolean
  include CustomActions::ValidateAllowedValue

  def allowed_values
    [
      { label: I18n.t(:general_text_yes), value: ProyeksiApp::Database::DB_VALUE_TRUE },
      { label: I18n.t(:general_text_no), value: ProyeksiApp::Database::DB_VALUE_FALSE }
    ]
  end

  def type
    :boolean
  end

  def validate(errors)
    validate_allowed_value(errors, :actions)
    super
  end
end
