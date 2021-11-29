#-- encoding: UTF-8



require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Errors
      class ErrorRepresenter < Roar::Decorator
        include Roar::JSON::HAL
        include Roar::Hypermedia

        self.as_strategy = API::Utilities::CamelCasingStrategy.new

        property :_type, exec_context: :decorator
        property :error_identifier, exec_context: :decorator, render_nil: true
        property :message, getter: ->(*) { message }, render_nil: true
        property :details, embedded: true

        collection :errors,
                   embedded: true,
                   class: ::API::Errors::ErrorBase,
                   decorator: ::API::V3::Errors::ErrorRepresenter,
                   if: ->(*) { !Array(errors).empty? }

        def _type
          'Error'
        end

        def error_identifier
          ::API::V3::URN_ERROR_PREFIX + represented.class.identifier
        end
      end
    end
  end
end
