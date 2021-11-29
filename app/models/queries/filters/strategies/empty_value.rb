#-- encoding: UTF-8



module Queries::Filters::Strategies
  class EmptyValue < BaseStrategy
    def validate
      super

      unless values.empty?
        errors.add(:values, "must be empty")
      end
    end
  end
end
