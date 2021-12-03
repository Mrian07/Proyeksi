#-- encoding: UTF-8

module AssignableCustomFieldValues
  extend ActiveSupport::Concern

  included do
    def assignable_custom_field_values(custom_field)
      case custom_field.field_format
      when 'list'
        custom_field.possible_values
      when 'version'
        assignable_versions
      end
    end
  end
end
