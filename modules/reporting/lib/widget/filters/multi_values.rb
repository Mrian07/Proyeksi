

# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::MultiValues < Widget::Filters::Base
  def render
    write(content_tag(:div, id: "#{filter_class.underscore_name}_arg_1", class: 'advanced-filters--filter-value') do
      select_options = {  "data-remote-url": url_for(action: 'available_values'),
                          "data-initially-selected": JSON::dump(Array(filter.values).flatten),
                          style: 'vertical-align: top;', # FIXME: Do CSS
                          name: "values[#{filter_class.underscore_name}][]",
                          "data-loading": @options[:lazy] ? 'ajax' : '',
                          id: "#{filter_class.underscore_name}_arg_1_val",
                          class: 'form--select filter-value',
                          "data-filter-name": filter_class.underscore_name }
      box_content = ''.html_safe
      label = label_tag "#{filter_class.underscore_name}_arg_1_val",
                        h(filter_class.label) + ' ' + I18n.t(:label_filter_value),
                        class: 'hidden-for-sighted'

      box = content_tag :select, select_options, id: "#{filter_class.underscore_name}_select_1" do
        render_widget Widget::Filters::Option, filter, to: box_content unless @options[:lazy]
      end
      plus = content_tag :a,
                         href: '#',
                         class: 'form-label filter_multi-select -transparent',
                         "data-filter-name": filter_class.underscore_name,
                         title: I18n.t(:description_multi_select) do
        content_tag :span,
                    '',
                    class: 'icon-context icon-button icon-add icon4',
                    title: I18n.t(:label_enable_multi_select) do
          content_tag :span, I18n.t(:label_enable_multi_select), class: 'hidden-for-sighted'
        end
      end

      content_tag(:span, class: 'inline-label') do
        label + box + plus
      end
    end)
  end
end
