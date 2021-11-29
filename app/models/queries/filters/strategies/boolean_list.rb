#-- encoding: UTF-8



module Queries::Filters::Strategies
  class BooleanList < List
    def validate
      super

      if too_many_values
        errors.add(:values, "only one value allowed")
      end
    end

    def valid_values!
      filter.values &= allowed_values.map(&:last).map(&:to_s)
    end

    private

    def operator_map
      super_value = super.dup
      super_value['='] = ::Queries::Operators::BooleanEquals
      super_value['!'] = ::Queries::Operators::BooleanNotEquals

      super_value
    end

    def too_many_values
      values.reject(&:blank?).length > 1
    end
  end
end
