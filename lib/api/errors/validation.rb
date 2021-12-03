#-- encoding: UTF-8

module API
  module Errors
    class Validation < ErrorBase
      identifier 'PropertyConstraintViolation'
      code 422

      def initialize(property, full_message)
        super full_message

        @property = property
        @details = { attribute: property }
      end
    end
  end
end
