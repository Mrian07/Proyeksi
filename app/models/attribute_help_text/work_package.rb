

class AttributeHelpText::WorkPackage < AttributeHelpText
  def self.available_attributes
    attributes = ::Type.translated_work_package_form_attributes

    # Start and finish dates are joined into a single field for non-milestones
    attributes.delete 'start_date'
    attributes.delete 'due_date'

    # Status and project are currently special attribute that we need to add
    attributes['status'] = WorkPackage.human_attribute_name 'status'
    attributes['project'] = WorkPackage.human_attribute_name 'project'

    attributes
  end

  validates :attribute_name, inclusion: { in: ->(*) { available_attributes.keys } }

  def type_caption
    I18n.t(:label_work_package)
  end

  def self.visible_condition(user)
    visible_cf_names = WorkPackageCustomField
                       .visible_by_user(user)
                       .pluck(:id)
                       .map { |id| "custom_field_#{id}" }

    ::AttributeHelpText
      .where(attribute_name: visible_cf_names)
      .or(::AttributeHelpText.where.not("attribute_name LIKE 'custom_field_%'"))
  end
end
