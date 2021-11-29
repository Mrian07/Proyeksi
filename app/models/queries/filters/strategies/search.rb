#-- encoding: UTF-8



module Queries::Filters::Strategies
  class Search < BaseStrategy
    self.supported_operators = ['**']
    self.default_operator = '**'
  end
end
