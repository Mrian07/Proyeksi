#-- encoding: UTF-8



module Queries::Filters::Strategies
  class Date < Queries::Filters::Strategies::Integer
    self.supported_operators = ['<t+', '>t+', 't+', 't', 'w', '>t-', '<t-', 't-', '=d', '<>d']
    self.default_operator = 't'

    def validate
      if operator == Queries::Operators::OnDate ||
         operator == Queries::Operators::BetweenDate
        validate_values_all_date
      else
        super
      end
    end

    private

    def validate_values_all_date
      unless values.all? { |value| value.blank? || date?(value) }
        errors.add(:values, I18n.t('activerecord.errors.messages.not_a_date'))
      end
    end

    def date?(str)
      true if ::Date.parse(str)
    rescue ArgumentError
      false
    end
  end
end
