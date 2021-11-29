

module Costs::NumberHelper
  # Turns a string representing a number in the current locale
  # to a string representing a number in en (without delimiters).
  def parse_number_string(value)
    return value unless value&.is_a?(String) && value.present?

    value = value.strip

    # All locales seem to have their delimiters set to "".
    # We thus remove all typical delimiters that are not the separator.
    separator =
      if I18n.exists?(:'number.currency.format.separator')
        I18n.t(:'number.currency.format.separator')
      else
        I18n.t(:'number.format.separator', default: '.')
      end

    if separator
      delimiters = Regexp.new('[ .,’˙]'.gsub(separator, ''))

      value.gsub!(delimiters, '')

      value.gsub!(separator, '.')
    end

    value
  end

  # Turns a string representing a number in the current locale
  # to a BigDecimal number.
  #
  # In case the string cannot be parsed, 0.0 is returned.
  def parse_number_string_to_number(value)
    BigDecimal(parse_number_string(value))
  rescue TypeError, ArgumentError
    0.0
  end

  # Output currency value without unit
  def unitless_currency_number(value)
    number_to_currency(value, format: '%n')
  end

  def to_currency_with_empty(rate)
    rate.nil? ? '0.0' : number_to_currency(rate.rate)
  end
end
