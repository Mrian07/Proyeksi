#-- encoding: UTF-8



module API
  module Errors
    class InvalidUserStatusTransition < ErrorBase
      identifier 'InvalidUserStatusTransition'
      code 400

      def initialize(*)
        super I18n.t('api_v3.errors.invalid_user_status_transition')
      end
    end
  end
end
