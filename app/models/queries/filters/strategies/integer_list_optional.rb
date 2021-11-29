

module Queries::Filters::Strategies
  class IntegerListOptional < ::Queries::Filters::Strategies::Integer
    self.supported_operators = ['=', '!', '*', '!*']
  end
end
