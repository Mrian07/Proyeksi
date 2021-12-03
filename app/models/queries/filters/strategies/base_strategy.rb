#-- encoding: UTF-8

module Queries::Filters::Strategies
  class BaseStrategy
    attr_accessor :filter

    class_attribute :supported_operators,
                    :default_operator

    delegate :values,
             :errors,
             to: :filter

    def initialize(filter)
      self.filter = filter
    end

    def validate; end

    def operator
      operator_map
        .slice(*self.class.supported_operators)[filter.operator]
    end

    def valid_values!; end

    def supported_operator_classes
      operator_map
        .slice(*self.class.supported_operators)
        .map(&:last)
        .sort_by { |o| self.class.supported_operators.index o.symbol.to_s }
    end

    def default_operator_class
      operator = self.class.default_operator || self.class.available_operators.first
      operator_map[operator]
    end

    private

    def operator_map
      ::Queries::Operators::OPERATORS
    end
  end
end
