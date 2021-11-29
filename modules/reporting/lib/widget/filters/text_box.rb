

# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::TextBox < Widget::Filters::Base
  def render
    label = content_tag :label,
                        "#{h(filter_class.label)} #{I18n.t(:label_filter_value)}",
                        for: "#{filter_class.underscore_name}_arg_1_val",
                        class: 'hidden-for-sighted'

    write(content_tag(:div, id: "#{filter_class.underscore_name}_arg_1", class: 'advanced-filters--filter-value') do
      label + text_field_tag("values[#{filter_class.underscore_name}]", '',
                             size: '6',
                             class: 'advanced-filters--text-field',
                             id: "#{filter_class.underscore_name}_arg_1_val",
                             'data-filter-name': filter_class.underscore_name)
    end)
  end
end
