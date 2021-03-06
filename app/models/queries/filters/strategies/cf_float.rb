#-- encoding: UTF-8

module Queries::Filters::Strategies
  class CfFloat < BaseStrategy
    include Queries::Filters::Strategies::Numeric
    include Queries::Filters::Strategies::CfNumeric
    include Queries::Filters::Strategies::FloatNumeric
  end
end
