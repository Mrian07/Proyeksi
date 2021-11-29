

# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::MultiChoice < Widget::Filters::Base
  def render
    filterName = filter_class.underscore_name
    result = content_tag :div, id: "#{filterName}_arg_1", class: 'advanced-filters--filter-value' do
      choices = filter_class.available_values.each_with_index.map do |(label, value), i|
        opts = {
          type: 'radio',
          name: "values[#{filterName}][]",
          id: "#{filterName}_radio_option_#{i}",
          value: value
        }
        opts[:checked] = 'checked' if filter.values == [value].flatten
        radio_button = tag :input, opts
        content_tag :label, radio_button + translate(label),
                    for: "#{filterName}_radio_option_#{i}",
                    'data-filter-name': filter_class.underscore_name,
                    class: "#{filterName}_radio_option filter_radio_option"
      end
      content_tag :div, choices.join.html_safe,
                  id: "#{filter_class.underscore_name}_arg_1_val"
    end
    write result
  end

  private

  def translate(label)
    if label.is_a?(Symbol)
      ::I18n.t(label)
    else
      label
    end
  end
end
