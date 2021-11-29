#-- encoding: UTF-8



module Queries::Filters::Strategies
  class IntegerList < ::Queries::Filters::Strategies::Integer
    self.supported_operators = ['!', '=']
  end
end
