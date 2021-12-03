#-- encoding: UTF-8

module API
  module Errors
    class ParseError < InvalidRequestBody
      identifier InvalidRequestBody.identifier
      code 400

      def initialize(_message = nil, details: nil)
        super I18n.t('api_v3.errors.invalid_json')

        if details
          @details = { parseError: clean_parse_error(details) }
        end
      end

      private

      def clean_parse_error(message)
        message.gsub(/\s?\[parse.c:\d+\]/, '')
      end
    end
  end
end
