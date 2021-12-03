#-- encoding: UTF-8

module API
  module Errors
    class NotImplemented < ErrorBase
      identifier 'NotImplemented'.freeze
      code 501

      def initialize(error_message = 'Not yet implemented'.freeze, **)
        super error_message
      end
    end
  end
end
