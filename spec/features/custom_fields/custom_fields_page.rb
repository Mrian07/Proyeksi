

class CustomFieldsPage
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  def visit_new(type = 'WorkPackageCustomField')
    visit new_custom_field_path type: type
  end

  def name_attribute
    find '#custom_field_name'
  end

  def default_value_attributes
    find '#custom_field_default_value_attributes span[lang]'
  end
end
