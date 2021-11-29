#-- encoding: UTF-8



module Queries::Filters::Strategies
  class List < BaseStrategy
    delegate :allowed_values,
             to: :filter

    self.supported_operators = ['=', '!']
    self.default_operator = '='

    def validate
      # TODO: the -1 is a special value that exists for historical reasons
      # so one can send the operator '=' and the values ['-1']
      # which results in a IS NULL check in the DB.
      # Remove once timelines is removed.
      if non_valid_values?
        errors.add(:values, :inclusion)
      end
    end

    def valid_values!
      filter.values &= (allowed_values.map(&:last).map(&:to_s) + ['-1'])
    end

    def non_valid_values?
      (values.reject(&:blank?) & (allowed_values.map(&:last).map(&:to_s) + ['-1'])) != values.reject(&:blank?)
    end
  end
end
