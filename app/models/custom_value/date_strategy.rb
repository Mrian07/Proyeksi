#-- encoding: UTF-8



class CustomValue::DateStrategy < CustomValue::FormatStrategy
  include Redmine::I18n

  def typed_value
    unless value.blank?
      Date.iso8601(value)
    end
  end

  def formatted_value
    format_date(value.to_date)
  rescue StandardError
    value.to_s
  end

  def validate_type_of_value
    return nil if value.is_a? Date

    begin
      Date.iso8601(value)
      nil
    rescue StandardError
      :not_a_date
    end
  end
end
