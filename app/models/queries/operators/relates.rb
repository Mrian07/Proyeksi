#-- encoding: UTF-8

module Queries::Operators
  class Relates < Base
    label 'relates'
    set_symbol ::Relation::TYPE_RELATES
  end
end
