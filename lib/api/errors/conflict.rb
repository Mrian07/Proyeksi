#-- encoding: UTF-8

module API
  module Errors
    class Conflict < ErrorBase
      identifier 'UpdateConflict'
      code 409

      def initialize(*args)
        opts = args.last.is_a?(Hash) ? args.last : {}

        super opts[:message] || I18n.t('api_v3.errors.code_409')
      end
    end
  end
end
