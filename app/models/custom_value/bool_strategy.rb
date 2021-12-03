#-- encoding: UTF-8

class CustomValue::BoolStrategy < CustomValue::FormatStrategy
  def value_present?
    present?(value)
  end

  def typed_value
    return nil unless value_present?

    ActiveRecord::Type::Boolean.new.cast(value)
  end

  def formatted_value
    if checked?
      I18n.t(:general_text_Yes)
    else
      I18n.t(:general_text_No)
    end
  end

  def checked?
    ActiveRecord::Type::Boolean.new.cast(value)
  end

  def parse_value(val)
    parsed_val = if !present?(val)
                   nil
                 elsif ActiveRecord::Type::Boolean::FALSE_VALUES.include?(val)
                   ProyeksiApp::Database::DB_VALUE_FALSE
                 else
                   ProyeksiApp::Database::DB_VALUE_TRUE
                 end

    super(parsed_val)
  end

  def validate_type_of_value; end

  private

  def present?(val)
    # can't use :blank? safely, because false.blank? == true
    # can't use :present? safely, because false.present? == false
    !val.nil? && val != ''
  end
end
