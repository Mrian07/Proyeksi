#-- encoding: UTF-8

module Queries::Filters::Strategies
  module Numeric
    def self.included(base)
      base.supported_operators = ['=', '!', '>=', '<=', '!*', '*']
      base.default_operator = '='
    end

    def validate
      validate_values_all_numeric
    end

    private

    def numeric_class
      raise NotImplementedError
    end

    def error_message
      raise NotImplementedError
    end

    def validate_values_all_numeric
      if operator && operator.requires_value? && values.any? { |value| !numeric?(value) }
        errors.add(:values, I18n.t("activerecord.errors.messages.#{error_message}"))
      end
    end

    def numeric?(str)
      true if Object.send(numeric_class.to_s, str)
    rescue ArgumentError
      false
    end
  end
end
