#-- encoding: UTF-8



module Queries::Filters::Strategies
  class CfInteger < BaseStrategy
    include Queries::Filters::Strategies::Numeric
    include Queries::Filters::Strategies::CfNumeric
    include Queries::Filters::Strategies::IntegerNumeric
  end
end
