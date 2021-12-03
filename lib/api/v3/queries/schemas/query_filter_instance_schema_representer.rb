#-- encoding: UTF-8

require 'queries/operators'

module API
  module V3
    module Queries
      module Schemas
        class QueryFilterInstanceSchemaRepresenter < ::API::Decorators::SchemaRepresenter
          include API::Utilities::RepresenterToJsonCache

          schema :name,
                 type: 'String',
                 writable: false,
                 has_default: true,
                 required: true

          def self.filter_representer
            ::API::V3::Queries::Filters::QueryFilterRepresenter
          end

          def self.filter_link_factory
            ->(*) do
              {
                href: api_v3_paths.query_filter(convert_attribute(filter.name)),
                title: filter.human_name
              }
            end
          end

          schema_with_allowed_collection :filter,
                                         type: 'QueryFilter',
                                         required: true,
                                         writable: true,
                                         values_callback: -> {
                                           [filter]
                                         },
                                         value_representer: filter_representer,
                                         link_factory: filter_link_factory

          def self.operator_representer
            ::API::V3::Queries::Operators::QueryOperatorRepresenter
          end

          def self.operator_link_factory
            ->(operator) do
              {
                href: api_v3_paths.query_operator(operator.to_query),
                title: operator.human_name
              }
            end
          end

          schema_with_allowed_collection :operator,
                                         type: 'QueryOperator',
                                         writable: true,
                                         has_default: false,
                                         required: true,
                                         values_callback: -> {
                                           filter.available_operators
                                         },
                                         value_representer: operator_representer,
                                         link_factory: operator_link_factory

          # While this is not actually the represented class,
          # this is what the superclass expects in order to have the
          # right i18n
          def self.represented_class
            WorkPackage
          end

          alias :filter :represented

          def _type
            'QueryFilterInstanceSchema'
          end

          def _name
            convert_attribute(filter.name)
          end

          def _dependencies
            [
              ::API::V3::Schemas::SchemaDependencyRepresenter.new(dependencies,
                                                                  'operator',
                                                                  current_user: current_user)
            ]
          end

          def convert_attribute(attribute)
            ::API::Utilities::PropertyNameConverter.from_ar_name(attribute)
          end

          def dependencies
            @dependencies ||= filter.available_operators.each_with_object({}) do |operator, hash|
              path = api_v3_paths.query_operator(operator.to_query)
              value = FilterDependencyRepresenterFactory.create(filter,
                                                                operator,
                                                                form_embedded: form_embedded)

              hash[path] = value
            end
          end

          def json_cacheable?
            dependencies
              .values
              .all?(&:json_cacheable?)
          end

          def json_cache_key
            dependencies
              .values
              .flat_map(&:json_cache_key)
              .uniq + [form_embedded, filter.name]
          end
        end
      end
    end
  end
end
