#-- encoding: UTF-8

module API
  module V3
    module Utilities
      class CustomFieldSumInjector < CustomFieldInjector
        def inject_schema(custom_field, _options = {})
          inject_basic_schema(custom_field)
        end

        def inject_basic_schema(custom_field)
          @class.schema property_name(custom_field.id),
                        type: TYPE_MAP[custom_field.field_format],
                        name_source: ->(*) { custom_field.name },
                        required: false,
                        writable: false,
                        show_if: ->(*) { custom_field.summable? }
        end

        def inject_property_value(custom_field)
          @class.property property_name(custom_field.id),
                          getter: property_value_getter_for(custom_field),
                          setter: property_value_setter_for(custom_field),
                          render_nil: true,
                          if: ->(*) { custom_field.summable? }
        end
      end
    end
  end
end
