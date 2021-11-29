#-- encoding: UTF-8



module API
  module Errors
    class TooManyRequests < ErrorBase
      identifier 'TooManyRequests'
      code 429

      def initialize(*args)
        opts = args.last.is_a?(Hash) ? args.last : {}

        super opts[:message] || I18n.t('api_v3.errors.code_429')
      end
    end
  end
end
