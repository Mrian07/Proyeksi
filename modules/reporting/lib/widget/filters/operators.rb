

# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::Operators < Widget::Filters::Base
  def render
    write(content_tag(:div, class: 'advanced-filters--filter-operator') do
      hide_select_box = (filter_class.available_operators.count == 1 || filter_class.heavy?)
      options = { class: 'advanced-filters--select filters-select filter_operator',
                  id: "operators[#{filter_class.underscore_name}]",
                  name: "operators[#{filter_class.underscore_name}]",
                  "data-filter-name": filter_class.underscore_name }
      options.merge! style: 'display: none' if hide_select_box

      select_box = content_tag :select, options do
        filter_class.available_operators.map do |o|
          opts = { value: h(o.to_s), "data-arity": o.arity }
          opts.reverse_merge! "data-forced": o.forced if o.forced?
          opts[:selected] = 'selected' if filter.operator.to_s == o.to_s
          content_tag(:option, opts) { h(I18n.t(o.label)) }
        end.join.html_safe
      end
      label1 = content_tag :label,
                           hidden_for_sighted_label,
                           for: "operators[#{filter_class.underscore_name}]",
                           class: 'hidden-for-sighted'
      label = content_tag :label do
        if filter_class.available_operators.any?
          filter_class.available_operators.first.label
        end
      end
      hide_select_box ? label1 + select_box + label : label1 + select_box
    end)
  end

  def hidden_for_sighted_label
    h(filter_class.label) + ' ' + I18n.t(:label_operator) + ' ' + I18n.t('js.filter.description.text_open_filter')
  end
end
