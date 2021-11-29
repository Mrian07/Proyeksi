#-- encoding: UTF-8



module API
  module Errors
    class InternalError < ErrorBase
      identifier 'InternalServerError'
      code 500

      def initialize(error_message = nil, **)
        error = I18n.t('api_v3.errors.code_500')

        if error_message
          error += " #{error_message}"
        end

        super error
      end
    end
  end
end
