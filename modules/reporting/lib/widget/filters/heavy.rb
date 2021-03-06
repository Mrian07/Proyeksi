

# FIXME: This basically is the MultiValues-Filter, except that we do not show
#        The select-box. This way we allow our JS to pretend this is just another
#        Filter. This is overhead...
#        But well this is again one of those temporary solutions.
# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::Heavy < Widget::Filters::Base
  def render
    # TODO: sometimes filter.values is of the form [["3"]] and somtimes ["3"].
    #       (using cost reporting)
    #       this might be a bug - further research would be fine
    values = filter.values.first.is_a?(Array) ? filter.values.first : filter.values
    opts = Array(values).empty? ? [] : values.map { |i| filter_class.label_for_value(i.to_i) }
    div = content_tag :div, id: "#{filter_class.underscore_name}_arg_1", class: 'advanced-filters--filter-value hidden' do
      select_options = {  "data-remote-url": url_for(action: 'available_values'),
                          "data-initially-selected": JSON::dump(Array(filter.values).flatten),
                          name: "values[#{filter_class.underscore_name}][]",
                          "data-loading": '',
                          id: "#{filter_class.underscore_name}_arg_1_val",
                          class: 'advanced-filters--select filter-value',
                          "data-filter-name": filter_class.underscore_name }
      box = content_tag :select, select_options do
        render_widget Widget::Filters::Option, filter, to: '', content: opts
      end
      box
    end
    alternate_text = opts.map(&:first).join(', ').html_safe
    write(div + content_tag(:label) do
      alternate_text
    end)
  end
end
