

class OpenProject::JournalFormatter::CustomField < ::JournalFormatter::Base
  include CustomFieldsHelper

  private

  def format_details(key, values)
    custom_field = ::CustomField.find_by(id: key.to_s.sub('custom_fields_', '').to_i)

    if custom_field
      label = custom_field.name
      old_value, value = get_formatted_values custom_field, values
    else
      label = I18n.t(:label_deleted_custom_field)
      old_value = values.first
      value = values.last
    end

    [label, old_value, value]
  end

  def get_formatted_values(custom_field, values)
    modifier_fn = method(get_modifier_function(custom_field))
    formatted_values custom_field, values, modifier_fn
  end

  def get_modifier_function(custom_field)
    case custom_field.field_format
    when 'list'
      :find_list_value
    when 'user'
      :find_user_value
    else
      :format_value
    end
  end

  def formatted_values(custom_field, values, modifier_fn)
    old_value, new_value = values
    old_option = modifier_fn.call(old_value, custom_field) if old_value
    new_option = modifier_fn.call(new_value, custom_field) if new_value

    [old_option || old_value, new_option || new_value]
  end

  def find_user_value(value, _custom_field)
    ids = value.split(",").map(&:to_i)

    # Lookup any visible user we can find
    user_lookup =
      Principal
      .in_visible_project_or_me(User.current)
      .where(id: ids)
      .index_by(&:id)

    ids.map do |id|
      if user_lookup.key?(id)
        user_lookup[id].name
      else
        I18n.t(:label_missing_or_hidden_custom_option)
      end
    end.join(', ')
  end

  def find_list_value(id, custom_field)
    ids = id.split(",").map(&:to_i)

    id_value = custom_field
               .custom_options
               .where(id: ids)
               .order(:position)
               .pluck(:id, :value)
               .to_h

    ids.map do |id|
      id_value[id] || I18n.t(:label_deleted_custom_option)
    end.join(', ')
  end
end
