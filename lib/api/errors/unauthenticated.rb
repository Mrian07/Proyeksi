#-- encoding: UTF-8

module API
  module Errors
    class Unauthenticated < ErrorBase
      identifier 'Unauthenticated'
      code 401

      def initialize(message = I18n.t('api_v3.errors.code_401'))
        super message
      end
    end
  end
end
