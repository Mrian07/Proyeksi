

# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::Date < Widget::Filters::Base
  def render
    @calendar_headers_tags_included = true

    name = "values[#{filter_class.underscore_name}][]"
    id_prefix = "#{filter_class.underscore_name}_"

    write(content_tag(:span, class: 'advanced-filters--filter-value -binary') do
      label1 = label_tag "#{id_prefix}arg_1_val",
                         h(filter_class.label) + ' ' + I18n.t(:label_filter_value),
                         class: 'hidden-for-sighted'

      arg1 = content_tag :span, id: "#{id_prefix}arg_1" do
        text1 = text_field_tag name, @filter.values.first.to_s,
                               size: 10,
                               class: 'advanced-filters--text-field -augmented-datepicker',
                               id: "#{id_prefix}arg_1_val",
                               'data-type': 'date'
        label1 + text1
      end

      label2 = label_tag "#{id_prefix}arg_2_val",
                         h(filter_class.label) + ' ' + I18n.t(:label_filter_value),
                         class: 'hidden-for-sighted'

      arg2 = content_tag :span, id: "#{id_prefix}arg_2", class: 'advanced-filters--filter-value2' do
        text2 = text_field_tag name.to_s, @filter.values.second.to_s,
                               size: 10,
                               class: 'advanced-filters--text-field -augmented-datepicker',
                               id: "#{id_prefix}arg_2_val",
                               'data-type': 'date'
        label2 + text2
      end

      arg1 + arg2
    end)
  end
end
