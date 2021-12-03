#-- encoding: UTF-8

module API
  module Errors
    class BadRequest < ErrorBase
      identifier 'BadRequest'
      code 400

      def initialize(message, **)
        super I18n.t('api_v3.errors.code_400', message: message)
      end
    end
  end
end
