#-- encoding: UTF-8

module API
  module Errors
    class UnsupportedMediaType < ErrorBase
      identifier 'TypeNotSupported'
      code 415

      def initialize(message)
        super message
      end
    end
  end
end
