

# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::Label < Widget::Filters::Base
  def render
    options = {
      id: filter_class.underscore_name,
      class: 'advanced-filters--filter-name',
      title: h(filter_class.label)
    }
    write(content_tag(:label, options) do
      h(filter_class.label)
    end)
  end
end
