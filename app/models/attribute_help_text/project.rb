class AttributeHelpText::Project < AttributeHelpText
  def self.available_attributes
    skip = %w[_type links _dependencies id created_at updated_at]

    attributes = API::V3::Projects::Schemas::ProjectSchemaRepresenter
                   .representable_definitions
                   .reject { |key, _| skip.include?(key.to_s) }
                   .transform_values { |definition| definition[:name_source].call }

    ProjectCustomField.all.each do |field|
      attributes["custom_field_#{field.id}"] = field.name
    end

    attributes
  end

  validates_inclusion_of :attribute_name, in: ->(*) { available_attributes.keys }

  def type_caption
    Project.model_name.human
  end

  def self.visible_condition(_user)
    ::AttributeHelpText.where(attribute_name: available_attributes.keys)
  end
end
