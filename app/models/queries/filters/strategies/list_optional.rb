#-- encoding: UTF-8



module Queries::Filters::Strategies
  class ListOptional < List
    self.supported_operators = ['=', '!', '*', '!*']
  end
end
