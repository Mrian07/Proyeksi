#-- encoding: UTF-8



require 'roar/decorator'
require 'roar/json/hal'

module API
  module Decorators
    class AllowedValuesByCollectionRepresenter < PropertySchemaRepresenter
      attr_accessor :allowed_values
      attr_reader :value_representer,
                  :link_factory,
                  :allowed_values_getter

      def initialize(type:,
                     name:,
                     value_representer:,
                     link_factory:,
                     location: :link,
                     required: true,
                     has_default: false,
                     writable: true,
                     attribute_group: nil,
                     current_user: nil,
                     allowed_values_getter: nil)
        @value_representer = value_representer
        @link_factory = link_factory
        @allowed_values_getter = allowed_values_getter

        super(type: type,
              name: name,
              required: required,
              has_default: has_default,
              writable: writable,
              attribute_group: attribute_group,
              location: location,
              current_user: current_user)
      end

      links :allowedValues do
        next unless allowed_values && link_factory && writable

        allowed_values.map do |value|
          link_factory.call(value)
        end
      end

      collection :allowed_values,
                 exec_context: :decorator,
                 embedded: true,
                 getter: ->(*) do
                   if allowed_values_getter
                     instance_exec(&allowed_values_getter)
                   else
                     allowed_values_getter_default
                   end
                 end

      private

      def allowed_values_getter_default
        return unless allowed_values && value_representer

        allowed_values.map do |value|
          representer = if value_representer.respond_to?(:call)
                          value_representer.(value)
                        else
                          value_representer
                        end

          representer.new(value, current_user: current_user)
        end
      end
    end
  end
end
