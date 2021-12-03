#-- encoding: UTF-8

module Queries::Filters::Strategies
  class String < BaseStrategy
    self.supported_operators = ['=', '~', '!', '!~']
    self.default_operator = '~'
  end
end
