#-- encoding: UTF-8

module CustomActions::Actions::Strategies::Associated
  include CustomActions::ValidateAllowedValue
  include CustomActions::ValuesToInteger

  def allowed_values
    @allowed_values ||= begin
                          options = associated
                                      .map { |value, label| { value: value, label: label } }

                          if required?
                            options
                          else
                            options.unshift(value: nil, label: I18n.t('placeholders.default'))
                          end
                        end
  end

  def apply(work_package)
    work_package.send(:"#{key}_id=", values.first)
  end

  def type
    :associated_property
  end

  def associated
    raise 'Not implemented error'
  end

  def validate(errors)
    validate_allowed_value(errors, :actions)
    super
  end
end
