#-- encoding: UTF-8

module Queries::Filters::Strategies
  class ListAll < List
    self.supported_operators = ['=', '!', '*']
  end
end
