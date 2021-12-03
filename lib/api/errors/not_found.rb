#-- encoding: UTF-8

module API
  module Errors
    class NotFound < ErrorBase
      identifier 'NotFound'
      code 404

      def initialize(_message = nil, exception: nil, model: nil)
        # Try to find a localizable error message for
        # the not found error by checking the "model" property set by rails.
        model ||= exception&.model&.underscore
        super not_found_message(model)
      end

      private


      def not_found_message(model)
        if model.present?
          I18n.t("api_v3.errors.not_found.#{model}", default: I18n.t('api_v3.errors.code_404'))
        else
          I18n.t('api_v3.errors.code_404')
        end
      end
    end
  end
end
