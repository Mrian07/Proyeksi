#-- encoding: UTF-8

module Queries::Filters::Strategies
  class Float < BaseStrategy
    include Queries::Filters::Strategies::Numeric
    include Queries::Filters::Strategies::FloatNumeric
  end
end
