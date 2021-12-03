#-- encoding: UTF-8

module Queries::Operators
  class Follows < Base
    label 'follows'
    set_symbol ::Relation::TYPE_FOLLOWS
  end
end
