#-- encoding: UTF-8

module Queries::Filters::Strategies
  class Integer < BaseStrategy
    include Queries::Filters::Strategies::Numeric
    include Queries::Filters::Strategies::IntegerNumeric
  end
end
