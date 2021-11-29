

# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::RemoveButton < Widget::Filters::Base
  def render
    hidden_field = tag :input, id: "rm_#{filter_class.underscore_name}",
                               name: 'fields[]', type: 'hidden', value: ''
    button = content_tag(:a, href: "#", class: "filter_rem") do
      icon_wrapper('icon-context advanced-filters--remove-filter-icon', I18n.t(:description_remove_filter))
    end

    write(content_tag(:div, hidden_field + button, id: "rm_box_#{filter_class.underscore_name}",
                                                   class: 'advanced-filters--remove-filter'))
  end
end
