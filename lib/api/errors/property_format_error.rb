#-- encoding: UTF-8



module API
  module Errors
    class PropertyFormatError < ErrorBase
      identifier 'PropertyFormatError'
      code 422

      attr_accessor :property

      def initialize(property, expected_format, actual_value)
        self.property = property

        message = I18n.t('api_v3.errors.invalid_format',
                         property: property,
                         expected_format: expected_format,
                         actual: actual_value)
        super message
      end

      def details
        { attribute: property }
      end
    end
  end
end
