#-- encoding: UTF-8



module API
  module Errors
    class ErrorBase < Grape::Exceptions::Base
      attr_reader :message, :details, :errors, :property

      delegate :code, to: :class

      class << self
        ##
        # Converts the given ActiveRecord errors into an Array of Error objects
        # (i.e. subclasses of ErrorBase)
        # In case the given errors contain 'critical' errors, the resulting Array will only
        # contain the critical error and no non-critical errors (avoiding information disclosure)
        # That means: The returned errors are always safe for display towards a user
        def create_errors(errors)
          if errors.has_key?(:base)
            base_errors = errors.symbols_for(:base)
            if base_errors.include?(:error_not_found)
              return [::API::Errors::NotFound.new]
            elsif base_errors.include?(:error_unauthorized)
              return [::API::Errors::Unauthorized.new]
            elsif base_errors.include?(:error_conflict)
              return [::API::Errors::Conflict.new]
            end
          end

          convert_ar_to_api_errors(errors)
        end

        ##
        # Like :create_errors, but creates a single MultipleErrors error if
        # more than one error would be returned otherwise.
        def create_and_merge_errors(errors)
          ::API::Errors::MultipleErrors.create_if_many(create_errors(errors))
        end

        ##
        # Allows defining this error class's identifier.
        # Used to read it otherwise.
        def identifier(identifier = nil)
          @identifier = identifier if identifier

          @identifier
        end

        ##
        # Allows defining this error class's http code
        # Used to read it otherwise.
        def code(status = nil)
          @code = status if status

          @code
        end

        private

        def convert_ar_to_api_errors(errors)
          api_errors = []

          errors.attribute_names.each do |attribute|
            api_attribute_name = ::API::Utilities::PropertyNameConverter.from_ar_name(attribute)

            errors.symbols_and_messages_for(attribute).each do |symbol, message|
              api_errors << if symbol == :error_readonly
                              ::API::Errors::UnwritableProperty.new(api_attribute_name, message)
                            else
                              ::API::Errors::Validation.new(api_attribute_name, message)
                            end
            end
          end

          api_errors
        end
      end

      def initialize(message, **)
        @message = message
        @errors = []

        super message: message
      end
    end
  end
end