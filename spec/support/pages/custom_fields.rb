

require 'support/pages/page'

module Pages
  class CustomFields < Page
    def path
      '/custom_fields'
    end

    def visit_tab(name)
      visit!
      within('content-tabs') do
        click_link name.to_s
      end
    end

    def select_format(label)
      select label, from: "custom_field_field_format"
    end

    def set_name(name)
      find("#custom_field_name").set name
    end

    def set_default_value(value)
      fill_in 'custom_field[default_value]', with: value
    end

    def set_all_projects(value)
      find('#custom_field_is_for_all').set value
    end

    def has_form_element?(name)
      page.has_css? "label.form--label", text: name
    end
  end
end
