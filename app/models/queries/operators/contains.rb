#-- encoding: UTF-8



module Queries::Operators
  class Contains < Base
    include Concerns::ContainsAllValues

    label 'contains'
    set_symbol '~'
  end
end
