#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Filters
        class QueryFilterInstanceRepresenter < ::API::Decorators::Single
          include API::Decorators::LinkedResource

          def initialize(model)
            super(model, current_user: nil, embed_links: true)
          end

          link :schema do
            api_v3_paths.query_filter_instance_schema(converted_name)
          end

          resource_link :filter,
                        getter: ->(*) {
                          {
                            href: api_v3_paths.query_filter(converted_name),
                            title: name
                          }
                        },
                        setter: ->(**) {
                          # nothing for now, handled in QueryRepresenter
                        }

          resource_link :operator,
                        getter: ->(*) {
                          next if represented.operator.nil?

                          hash = {
                            href: api_v3_paths.query_operator(CGI.escape(represented.operator))
                          }

                          hash[:title] = represented.operator_class.human_name if represented.operator_class.present?
                          hash
                        },
                        setter: ->(fragment:, **) {
                          next unless fragment

                          represented.operator = ::API::Utilities::ResourceLinkParser
                                                 .parse_id fragment["href"],
                                                           property: 'operator',
                                                           expected_version: '3',
                                                           expected_namespace: 'queries/operators'
                        }

          resources :values,
                    link: ->(*) {
                      next unless represented.ar_object_filter?

                      represented.value_objects.map do |value_object|
                        href = begin
                          path_name = value_object.class.name.demodulize.underscore

                          api_v3_paths.send(path_name, value_object.id)
                        rescue StandardError => e
                          Rails.logger.error "Failed to get href for value_object #{value_object}: #{e}"
                          nil
                        end

                        link_object = {
                          href: href,
                          title: value_object.name
                        }

                        if value_object.is_a?(::Queries::Filters::TemplatedValue)
                          link_object[:templated] = true
                        end

                        link_object
                      end
                    },
                    setter: ->(fragment:, **) {
                      next unless fragment

                      if represented.ar_object_filter?
                        set_link_values(fragment)
                      else
                        set_property_values(fragment)
                      end
                    },
                    getter: ->(*) {
                      if represented_is_boolean_list?(represented)
                        represented.values.map do |value|
                          value == ProyeksiApp::Database::DB_VALUE_TRUE
                        end
                      else
                        represented.values
                      end
                    },
                    skip_render: ->(*) { represented.ar_object_filter? },
                    embedded: false

          property :name,
                   exec_context: :decorator,
                   writeable: false

          def _type
            "#{converted_name.camelize}QueryFilter"
          end

          def name
            represented.human_name
          end

          def set_link_values(vals)
            represented.values = vals.map do |value|
              ::API::Utilities::ResourceLinkParser.parse(value["href"])[:id]
            end
          end

          def set_property_values(vals)
            represented.values = if represented_is_boolean_list?(represented)
                                   vals.map do |value|
                                     if value
                                       ProyeksiApp::Database::DB_VALUE_TRUE
                                     else
                                       ProyeksiApp::Database::DB_VALUE_FALSE
                                     end
                                   end
                                 else
                                   vals
                                 end
          end

          def converted_name
            ::API::Utilities::PropertyNameConverter.from_ar_name(represented.name)
          end

          def query_filter_instance_links_representer(represented)
            ::API::V3::Queries::Filters::QueryFilterInstanceLinksRepresenter.new represented, current_user: current_user
          end

          def represented_is_boolean_list?(represented)
            represented.send(:type_strategy).is_a?(::Queries::Filters::Strategies::BooleanList)
          end
        end
      end
    end
  end
end
