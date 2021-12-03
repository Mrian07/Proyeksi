#-- encoding: UTF-8

require_relative 'base'

module Queries::Filters::Shared
  module CustomFields
    class ListOptional < Base
      def value_objects
        case custom_field.field_format
        when 'version'
          ::Version.where(id: values)
        when 'list'
          custom_field.custom_options.where(id: values)
        else
          super
        end
      end

      def ar_object_filter?
        true
      end

      def type
        :list_optional
      end

      protected

      def type_strategy_class
        ::Queries::Filters::Strategies::CfListOptional
      end
    end
  end
end
