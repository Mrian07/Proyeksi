#-- encoding: UTF-8



module API
  module Errors
    class UnwritableProperty < ErrorBase
      identifier 'PropertyIsReadOnly'
      code 422

      def initialize(property, message)
        super message

        @property = property
        @details = { attribute: property }
      end
    end
  end
end
