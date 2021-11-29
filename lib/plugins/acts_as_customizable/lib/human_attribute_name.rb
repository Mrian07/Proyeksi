

module Redmine
  module Acts
    module Customizable
      module HumanAttributeName
        # If a model acts_as_customizable it will inject attributes like 'custom_field_1' into itself.
        # Using this method, they can now be i18ned same as every other attribute. This is for example
        # for error messages following the format of '%{attribute} %{message}' where `attribute` is resolved
        # by calling IncludingClass.human_attribute_name
        def human_attribute_name(attribute, options = {})
          match = /\Acustom_field_(?<id>\d+)\z/.match(attribute)

          if match
            CustomField.find_by(id: match[:id]).name
          else
            super
          end
        end
      end
    end
  end
end
