#-- encoding: UTF-8

module Queries::Filters::Strategies
  module Validations
    private

    def date?(str)
      true if Date.parse(str)
    rescue StandardError
      false
    end

    def validate
      unless values.all? { |value| value.blank? || date?(value) }
        errors.add(:values, I18n.t('activerecord.errors.messages.not_a_date'))
      end
    end

    def integer?(str)
      true if Integer(str)
    rescue StandardError
      false
    end
  end
end
