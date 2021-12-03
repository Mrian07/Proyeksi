#-- encoding: UTF-8

module Queries::Filters::Strategies
  class CfListOptional < ListOptional
    private

    def operator_map
      super_value = super.dup
      super_value['!*'] = ::Queries::Operators::NoneOrBlank
      super_value['*'] = ::Queries::Operators::AllAndNonBlank

      super_value
    end
  end
end
