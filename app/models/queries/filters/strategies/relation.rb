#-- encoding: UTF-8

module Queries::Filters::Strategies
  class Relation < BaseStrategy
    delegate :allowed_values_subset,
             to: :filter

    self.supported_operators = ::Relation::TYPES.keys + %w(parent children)
    self.default_operator = ::Relation::TYPE_RELATES

    def validate
      unique_values = values.uniq
      allowed_and_desired_values = allowed_values_subset & unique_values

      if allowed_and_desired_values.sort != unique_values.sort
        errors.add(:values, :inclusion)
      end
      if too_many_values
        errors.add(:values, "only one value allowed")
      end
    end

    def valid_values!
      filter.values &= allowed_values.map(&:last).map(&:to_s)
    end

    private

    def too_many_values
      values.reject(&:blank?).length > 1
    end
  end
end
