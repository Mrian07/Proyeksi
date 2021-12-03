#-- encoding: UTF-8

require 'roar/decorator'
require 'roar/json/hal'

module API
  module Decorators
    class PropertySchemaRepresenter < ::API::Decorators::Single
      include API::Decorators::FormattableProperty

      def initialize(
        type:, name:, location: nil, required: true, has_default: false, writable: true,
        attribute_group: nil, description: nil, current_user: nil
      )
        @type = type
        @name = name
        @required = required
        @has_default = has_default
        @writable = writable
        @attribute_group = attribute_group
        @location = derive_location(location)
        @description = description

        super(nil, current_user: current_user)
      end

      attr_accessor :type,
                    :name,
                    :required,
                    :has_default,
                    :writable,
                    :attribute_group,
                    :min_length,
                    :max_length,
                    :regular_expression,
                    :options,
                    :location,
                    :description

      property :type, exec_context: :decorator
      property :name, exec_context: :decorator
      property :required, exec_context: :decorator
      property :has_default, exec_context: :decorator
      property :writable, exec_context: :decorator
      property :attribute_group, exec_context: :decorator
      property :min_length, exec_context: :decorator
      property :max_length, exec_context: :decorator
      property :regular_expression, exec_context: :decorator
      property :options, exec_context: :decorator

      property :location, exec_context: :decorator, render_nil: false

      formattable_property :description,
                           exec_context: :decorator,
                           render_nil: false,
                           setter: nil,
                           getter: ->(*) do
                             next unless description.present?
                             ::API::Decorators::Formattable.new(description)
                           end

      private

      def model_required?
        # we never pass a model to our superclass
        false
      end

      ##
      # Derive the frontend location value to be passed
      # either nil, _links, or _meta depending on the input
      def derive_location(location)
        case location.to_s
        when 'link'
          :_links
        when 'meta'
          :_meta
        when ''
          nil
        else
          raise ArgumentError, "Invalid location attribute #{location}"
        end
      end
    end
  end
end
