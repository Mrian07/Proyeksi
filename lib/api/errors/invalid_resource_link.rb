#-- encoding: UTF-8



module API
  module Errors
    class InvalidResourceLink < ErrorBase
      identifier 'ResourceTypeMismatch'
      code 422

      def initialize(property_name, expected_link, actual_link)
        expected_i18n = Array(expected_link).join("' #{I18n.t('concatenation.single')} '")

        message = I18n.t('api_v3.errors.invalid_resource',
                         property: property_name,
                         expected: expected_i18n,
                         actual: actual_link)

        super message
      end
    end
  end
end
