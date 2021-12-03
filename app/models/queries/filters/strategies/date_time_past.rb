#-- encoding: UTF-8

module Queries::Filters::Strategies
  class DateTimePast < Queries::Filters::Strategies::Integer
    self.supported_operators = ['>t-', '<t-', 't-', 't', 'w', '=d', '<>d']
    self.default_operator = '>t-'

    def validate
      if operator == Queries::Operators::OnDateTime ||
        operator == Queries::Operators::BetweenDateTime
        validate_values_all_datetime
      else
        super
      end
    end

    private

    def operator_map
      super_value = super.dup
      super_value['=d'] = Queries::Operators::OnDateTime
      super_value['<>d'] = Queries::Operators::BetweenDateTime

      super_value
    end

    def validate_values_all_datetime
      unless values.all? { |value| value.blank? || datetime?(value) }
        errors.add(:values, I18n.t('activerecord.errors.messages.not_a_datetime'))
      end
    end

    def datetime?(str)
      true if ::DateTime.parse(str)
    rescue ArgumentError
      false
    end
  end
end
