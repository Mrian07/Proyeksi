#-- encoding: UTF-8

module API
  module V3
    module Utilities
      class CustomFieldInjector
        module LinkValueGetter
          def self.link_for(custom_field)
            ->(*) do
              next unless represented.available_custom_fields.include?(custom_field)

              # we can't use the generated accessor (e.g. represented.send :custom_field_1) here,
              # because we need to generate a link even if the id does not belong to an existing
              # object (that behaviour is only required for form payloads)
              values = Methods.link_value_getter_values represented, custom_field

              if custom_field.multi_value?
                values
              else
                values.first || Methods.single_empty_value
              end
            end
          end

          ##
          # Since the block returned by .new above is `instance_exec`'d some place else we need to
          # refer to this module in order to be able to split up the logic into methods.
          module Methods
            extend API::V3::Utilities::PathHelper

            module_function

            def link_value_getter_values(represented, custom_field)
              Array(represented.custom_value_for(custom_field)).flat_map do |custom_value|
                if custom_value && custom_value.value.present?
                  title = link_value_title(custom_value)

                  [{
                     title: title,
                     href: link_value_href(custom_field, custom_value)
                   }]
                else
                  []
                end
              end
            end

            def link_value_href(custom_field, custom_value)
              # only use ids for url
              return unless custom_value.value.to_i.to_s == custom_value.value

              path_method = link_value_path_method(custom_field, custom_value)
              api_v3_paths.send(path_method, custom_value.value)
            end

            def link_value_path_method(custom_field, custom_value)
              case custom_field.field_format
              when 'user'
                derive_principal_path_method(custom_value)
              when 'list'
                :custom_option
              else
                custom_field.field_format
              end
            end

            def derive_principal_path_method(custom_value)
              API::V3::Principals::PrincipalType.for(custom_value.typed_value)
            end

            def link_value_title(custom_value)
              if custom_value.typed_value.respond_to?(:name)
                custom_value.typed_value.name
              else
                custom_value.typed_value
              end
            end

            ##
            # While multi value custom fields are expected to simply return an empty array
            # if they have no value a normal single value custom field is expected by
            # the frontend to return a single element with a null href and title.
            def single_empty_value
              { href: nil, title: nil }
            end
          end
        end
      end
    end
  end
end
