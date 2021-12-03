#-- encoding: UTF-8

module API
  module Errors
    class InvalidSignal < ErrorBase
      identifier 'InvalidSignal'
      code 400

      def initialize(invalid, supported, type)
        message = I18n.t("api_v3.errors.invalid_signal.#{type}",
                         invalid: Array(invalid).join(', '),
                         supported: Array(supported).join(', '))
        super message
      end
    end
  end
end
