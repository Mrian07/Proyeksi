#-- encoding: UTF-8

module API
  module Errors
    class MultipleErrors < ErrorBase
      identifier 'MultipleErrors'
      code 422

      def self.create_if_many(errors)
        raise ArgumentError, 'expected at least one error' unless errors.any?
        return errors.first if errors.count == 1

        MultipleErrors.new(errors)
      end

      def initialize(errors)
        super I18n.t('api_v3.errors.multiple_errors')

        @errors = errors
      end
    end
  end
end
