#-- encoding: UTF-8

module Queries::Filters::Strategies
  class BooleanListStrict < BooleanList
    def operator_map
      super_value = super.dup
      super_value['='] = ::Queries::Operators::BooleanEqualsStrict

      super_value
    end
  end
end
