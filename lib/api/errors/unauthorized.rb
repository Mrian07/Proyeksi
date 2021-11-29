#-- encoding: UTF-8



module API
  module Errors
    class Unauthorized < ErrorBase
      identifier 'MissingPermission'
      code 403

      def initialize(*args)
        opts = args.last.is_a?(Hash) ? args.last : {}

        super opts[:message] || I18n.t('api_v3.errors.code_403')
      end
    end
  end
end
