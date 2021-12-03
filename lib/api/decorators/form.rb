#-- encoding: UTF-8

module API
  module Decorators
    class Form < ::API::Decorators::Single
      def initialize(represented, current_user: nil, errors: [], meta: nil)
        @errors = errors
        @meta = meta
        super(represented, current_user: current_user)
      end

      property :payload,
               embedded: true,
               exec_context: :decorator,
               getter: ->(*) {
                 payload_representer
               }
      property :schema,
               embedded: true,
               exec_context: :decorator,
               getter: ->(*) {
                 schema_representer
               }
      property :validation_errors, embedded: true, exec_context: :decorator

      def _type
        'Form'
      end

      def validation_errors
        @errors.group_by(&:property).inject({}) do |hash, (property, errors)|
          error = ::API::Errors::MultipleErrors.create_if_many(errors)
          hash[property] = ::API::V3::Errors::ErrorRepresenter.new(error)
          hash
        end
      end

      protected

      attr_reader :meta
    end
  end
end
