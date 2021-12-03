#-- encoding: UTF-8

module Queries::Filters::Strategies
  class HugeList < List
    delegate :allowed_values_subset,
             to: :filter

    def validate
      unique_values = values.uniq
      allowed_and_desired_values = allowed_values_subset & unique_values

      if allowed_and_desired_values.sort != unique_values.sort
        errors.add(:values, :inclusion)
      end
    end

    def valid_values!
      filter.values = allowed_values_subset
    end
  end
end
