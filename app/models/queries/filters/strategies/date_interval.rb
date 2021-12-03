#-- encoding: UTF-8

module Queries::Filters::Strategies
  class DateInterval < Queries::Filters::Strategies::Date
    self.supported_operators = ['<>d']
    self.default_operator = '<>d'
  end
end
